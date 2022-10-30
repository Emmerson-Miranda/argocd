# Introduction
Simple PoC to deploy some containers using basic helmcharts and a dynamic list of containers given in the values.yaml.

More info at: 
- https://github.com/argoproj/argocd-example-apps/tree/master/helm-guestbook



Installation instructions

```
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-03/example-03.app.yaml
```

Deleting

```
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-03/example-03.app.yaml
```