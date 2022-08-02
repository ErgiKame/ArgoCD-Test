## Some Glitches
#### On values.yaml at ingress-nginx chart admissionWebhooks: failurePolicy set to Ignore
#### ArgoCD runs only with https. You need to change it at argocd.yaml on argocd Deployment containers:- command: - argocd-server - --insecure