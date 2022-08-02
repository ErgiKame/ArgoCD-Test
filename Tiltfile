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
k8s_resource(workload="metallb-controller", new_name="Metallb Controller", labels=['Metallb'])
k8s_resource(workload="metallb-speaker", new_name="Metallb Speaker", labels=['Metallb'])

print("Ingress-Nginx")
print("===============================")
kustomize_with_helm('./k8s/local/ingress-nginx/')
k8s_resource(workload="ingress-nginx-controller", new_name="Ingress Nginx Controller", labels=['Ingress-Nginx'])
k8s_resource(workload="ingress-nginx-admission-create", new_name="Ingress Nginx Controller Admission", labels=['Ingress-Nginx'])
k8s_resource(workload="ingress-nginx-admission-patch", new_name="Ingress Nginx Controller Patch", labels=['Ingress-Nginx'])


print("Cert-Manager")
print("===============================")
kustomize_with_helm('./k8s/local/cert-manager/')
k8s_resource(workload="cert-manager", new_name="Cert Manager", labels=['Cert-Manager'])
k8s_resource(workload="cert-manager-cainjector", new_name="CA Injector", labels=['Cert-Manager'])
k8s_resource(workload="cert-manager-webhook", new_name="Webhook", labels=['Cert-Manager'])

# print("Postgres")
# print("===============================")
# kustomize_with_helm('./k8s/local/postgres/')
# k8s_resource(workload="postgresql", new_name="Postgresql", labels=['Postgresql'])
# k8s_resource(workload="postgres-postgresql", new_name="Postgres Postgresql", labels=['Postgresql'])

print("Argo CD")
print("===============================")
kustomize_with_helm('./k8s/local/argocd/')
k8s_resource(workload="argocd-server", new_name="ArgoCD Server", labels=['ArgoCD'])
k8s_resource(workload="argocd-repo-server", new_name="ArgoCD Repo Server", labels=['ArgoCD'])
k8s_resource(workload="argocd-redis", new_name="ArgoCD Redis", labels=['ArgoCD'])
k8s_resource(workload="argocd-notifications-controller", new_name="ArgoCD Notifications Controller", labels=['ArgoCD'])
k8s_resource(workload="argocd-dex-server", new_name="ArgoCD DEX Server", labels=['ArgoCD'])
k8s_resource(workload="argocd-applicationset-controller", new_name="ArgoCD Applicationset Controller", labels=['ArgoCD'])
k8s_resource(workload="argocd-application-controller", new_name="ArgoCD Application Controller", labels=['ArgoCD'])

print("Argo Apps")
print("===============================")
kustomize_with_helm('./k8s/local/argocd-apps/')
k8s_resource(objects=["api:application:argocd"], new_name="API", labels=['ArgoCD-Apps'], resource_deps=['Ingress Nginx Controller', 'ArgoCD Server'])
k8s_resource(objects=["postgres:application:argocd"], new_name="Postgres", labels=['ArgoCD-Apps'], resource_deps=['Ingress Nginx Controller', 'ArgoCD Server'])

print("Ingresses")
print("===============================")
kustomize_with_helm('./k8s/local/ingresses/')
k8s_resource(objects=["argo-ingress:Ingress:argocd"], new_name="ArgoCD Ingress", labels=['Ingresses'], resource_deps=['Ingress Nginx Controller', 'ArgoCD Server', 'ArgoCD-Apps'])
k8s_resource(objects=["api-ingress:Ingress:api"], new_name="API Ingress", labels=['Ingresses'], resource_deps=['Ingress Nginx Controller', 'ArgoCD Server', 'ArgoCD-Apps'])

