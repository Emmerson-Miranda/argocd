# Introduction (Work in progress)
App of apps with snyc waves.

Another example [here](https://github.com/jannfis/app-of-apps)

## etc/hosts

```bash
192.168.64.1    argocd.owl.com
```

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
"admin" password admin-password-argocd.txt file, created during cluster creation..

```bash
open -a firefox -g https://argocd.owl.com
```
