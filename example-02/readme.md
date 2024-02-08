# Introduction
Simple argo 'application' deploying using basic *Helm charts* without parameters and *without syncPolicy*. Uses Helm Chart source code from *git*.

More info at: 
- https://github.com/argoproj/argocd-example-apps/tree/master/helm-guestbook

Installation instructions

```
kubectl create namespace example-02
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-02/example-02.app.yaml
```

Deleting

```
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-02/example-02.app.yaml
```