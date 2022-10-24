# Introduction
Simple PoC to deploy some containers using very basic helmcharts.

Installation instructions

```
kubectl create namespace example-02
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-01/example-02.app.yaml
```