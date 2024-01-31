# Introduction
PoC to deploy in multiple environments using ApplicationSet, Helm and overriding some values per environment.

*The values are override using a values.yaml from another git repo.*

The environment generation is dynamic and comes from a git repo, for simplicity I used the same git repo but a different folder.


Installation instructions

Creating

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-09/example-09.appset.yaml
```

As per config in a separate git repo there is only one replica for DEV.
![3 environments](./example-09-dev.png)


As per config in a separate git repo there are three replicas for UAT.
![3 environments](./example-09-uat.png)

Deleting

```bash
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-09/example-09.appset.yaml
```