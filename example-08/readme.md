# Introduction
PoC to deploy in multiple environments using ApplicationSet, Helm and overriding some values per environment.

- Create applications dynamically
- Run helm chart from a git repository
- Inject values into chart from an external HTTP sources

The environment generation is dynamic and comes from a git repo.


## Installation instructions

Creating

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-08/example-08.appset.yaml
```

Deleting

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-08/example-08.appset.yaml
```