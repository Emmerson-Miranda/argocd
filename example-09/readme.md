# Introduction
PoC to deploy in multiple environments using ApplicationSet, Helm and overriding some values per environment.

- Helm chart pull from repository instead of git
- Values file inside of this repo



Installation instructions

Adding Helm repo to your console
```
helm repo add deliveryhero https://charts.deliveryhero.io/
```

Adding Helm repo to ArgoCD
```
argocd repo add https://charts.deliveryhero.io/ --type helm --name deliveryhero
```

Creating

```
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-09/example-09.appset.yaml
```

As per config in a separate git repo there is only one replica for DEV.
![3 environments](./example-09-dev.png)


As per config in a separate git repo there are three replicas for UAT.
![3 environments](./example-09-uat.png)

Deleting

```
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-09/example-09.appset.yaml
```