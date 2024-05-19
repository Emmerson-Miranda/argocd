# Introduction
Simple argo 'application' deploying using basic *Helm charts* without parameters and *without syncPolicy*. Uses Helm Chart source code from *git*.

More info at: 
- https://github.com/argoproj/argocd-example-apps/tree/master/helm-guestbook

## Cluster creation and destroy

Creation
```bash
./clusters-create.sh
```

Destroy
```bash
./clusters-destroy.sh
```

## ArgoCD UI
"admin" password admin-password-argocd.txt file, created during cluster creation.

```bash
open -a firefox -g https://argocd.owl.com
```
