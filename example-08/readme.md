# Introduction
Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *file values* and *with syncPolicy*. Uses Helm Chart source code from *git*. Inject values into chart from an *https source*. 


## Installation instructions

Creating

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-08/example-08.appset.yaml
```

Deleting

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-08/example-08.appset.yaml
```