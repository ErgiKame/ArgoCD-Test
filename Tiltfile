# -*- mode: Python -*

def kustomize_with_helm(directory):
  k8s_yaml(
    local(
      command='kubectl kustomize %s --enable-helm' % directory, 
      quiet=True
    )
  )

def get_path(path):
  return os.path.join(os.getcwd(), path)


AUTO_INIT=False
REGISTRY_PORT="5005"
LOCAL_REGISTRY="localhost:"+str(REGISTRY_PORT)
CLUSTER_REGISTRY="localhost:"+str(REGISTRY_PORT)

print("SET LOCAL REGISTRY")
print("Local:   " + LOCAL_REGISTRY)
print("Cluster: " + CLUSTER_REGISTRY)
print("===============================")
default_registry(
    LOCAL_REGISTRY,
    host_from_cluster=CLUSTER_REGISTRY
)


print("LOADING K8S")
print("===============================")

print("Metallb")
print("===============================")
kustomize_with_helm('./k8s/local/metallb/')

print("Ingress-Nginx")
print("===============================")
kustomize_with_helm('./k8s/local/ingress-nginx/')

print("Cert-Manager")
print("===============================")
kustomize_with_helm('./k8s/local/cert-manager/')
k8s_resource(workload="cert-manager", new_name="Cert Manager", labels=['Cert-Manager'])
k8s_resource(workload="cert-manager-cainjector", new_name="CA Injector", labels=['Cert-Manager'])
k8s_resource(workload="cert-manager-webhook", new_name="Webhook", labels=['Cert-Manager'])

print("Postgres")
print("===============================")
kustomize_with_helm('./k8s/local/postgres/')

print("Argo CD")
print("===============================")
kustomize_with_helm('./k8s/local/argocd/')