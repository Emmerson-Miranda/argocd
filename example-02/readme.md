# Introduction
Simple PoC to deploy some containers using very basic helmcharts.

This example is based on https://github.com/argoproj/argocd-example-apps/tree/master/helm-guestbook

Installation instructions

```
kubectl create namespace example-02
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-02/example-02.app.yaml
```