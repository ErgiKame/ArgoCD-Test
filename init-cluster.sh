#!/bin/bash
set -o errexit

export CLUSTER_NAME="argo"
export CLUSTER_REGISTRY="argo-registry"
export CLUSTER_REGISTRY_PORT="5000"

kind delete cluster --name $CLUSTER_NAME


# create registry container unless it already exists
export running="$(docker inspect -f '{{.State.Running}}' "${CLUSTER_REGISTRY}" 2>/dev/null)"
if [ -z "$running" ];
then
  docker run \
      -d --restart=always -p "${CLUSTER_REGISTRY_PORT}" --name "${CLUSTER_REGISTRY}" --net=kind \
      registry:2
else
  docker start "${CLUSTER_REGISTRY}"
fi

CLUSTER_REGISTRY_IP="$(docker inspect -f '{{.NetworkSettings.Networks.kind.IPAddress}}' "${CLUSTER_REGISTRY}")"
echo "Registry IP: ${CLUSTER_REGISTRY_IP}"

# create a cluster with the local registry enabled in containerd
cat <<EOF | kind create cluster --name "${CLUSTER_NAME}" --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: naxxa-cluster
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:${CLUSTER_REGISTRY_PORT}"]
    endpoint = ["http://${CLUSTER_REGISTRY_IP}:5000"]
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
  - containerPort: 443
    hostPort: 443
EOF

export connected="$(docker network connect "kind" "${CLUSTER_REGISTRY}" 2>/dev/null)"
if [ -z "$connected" ];
then
  echo "Registry already connected to kind network."
else
  docker network connect "kind" "${CLUSTER_REGISTRY}"
fi

kubectl cluster-info --context kind-$CLUSTER_NAME

# Document the local registry
# https://github.com/kubernetes/enhancements/tree/master/keps/sig-cluster-lifecycle/generic/1755-communicating-a-local-registry
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "localhost:${CLUSTER_REGISTRY_PORT}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
EOF


# tilt up