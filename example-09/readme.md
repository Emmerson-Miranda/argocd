# Introduction
Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, use external *Helm chart*(wiremock) with *file values* and *with syncPolicy*. Inject values into chart from a Git repo.
![Git generator](example-09-uat.png)

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
