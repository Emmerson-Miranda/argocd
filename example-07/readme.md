# Introduction
Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *file values* and *with syncPolicy*. Uses Helm Chart source code from *git*. Inject values into chart from a Git repo. 

The environment generation is dynamic and comes from a git repo.

DEV
![DEV](example-07-dev.png)

UAT
![UAT](example-07-uat.png)

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
