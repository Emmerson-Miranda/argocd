# Introduction
PoC to deploy in multiple environments using ApplicationSet, Helm and overriding some values per environment.

The environment generation is dynamic and comes from a git repo, for simplicity I used the same git repo but a different folder.

More info at: 
- https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/
- https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/
- https://argo-cd.readthedocs.io/en/stable/user-guide/helm/
- https://argocd-applicationset.readthedocs.io/en/stable/Generators/
- https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/
- https://github.com/argoproj/applicationset/tree/master/examples/git-generator-files-discovery


Installation instructions

Creating

```
kubectl apply -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-07/example-07.appset.yaml
```
![3 environments](./example-07.png)

Deleting

```
kubectl delete -n argocd -f https://raw.githubusercontent.com/Emmerson-Miranda/argocd/main/example-07/example-07.appset.yaml
```