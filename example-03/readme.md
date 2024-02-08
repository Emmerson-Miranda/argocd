# Introduction
Simple argo 'application' deploying using basic *Helm charts* without parameters and *with syncPolicy*. Uses Helm Chart source code from *git*. 

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