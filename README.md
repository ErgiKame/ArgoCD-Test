## Some Glitches
#### On values.yaml at ingress-nginx chart admissionWebhooks: failurePolicy set to Ignore
#### ArgoCD runs only with https. You need to change it at argocd.yaml on argocd Deployment containers:- command: - argocd-server - --insecure
#### To test argo-events webhook use: curl -X POST -H "Content-Type: application/json" -d '{"message": "Hello Webook!"}' http://eventsource.cluster.local/testing-webhook (Modify it in respect of post request url and endpoint name)

## General info
#### cd to /etc and sudo nano hosts (add ) 172.30.0.10 argo.cluster.local, 172.30.0.10 api.cluster.local, 172.30.0.10 eventsource.cluster.local (your ip might be different you need to set LoadBalancer IP. We do this to access the services not with ip but with DNS on local machine.

