# Introduction
PoC to deploy in multiple environments using ApplicationSet.

- Use an external Helm chart (wiremock)
- Inject values into chart from a git repository

The environment generation is dynamic and comes from a git repo.


## Installation instructions

Creating

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-09/example-09.appset.yaml
```

As per config in a separate git repo there are three replicas for UAT.
![3 environments](./example-09-uat.png)

Deleting

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-09/example-09.appset.yaml
```