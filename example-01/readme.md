# Introduction
Simple argo 'application' deploying using basic k8s manifests.

Installation instructions

```bash
kubectl create namespace example-01
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-01/example-01.app.yaml
```


Deleting

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-01/example-01.app.yaml
```