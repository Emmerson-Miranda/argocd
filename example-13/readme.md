# Introduction
Integrate ArgoCD with Hashicorp Vault using sidecar options.

This example replace secrets in plain manifests.


## etc/hosts

```bash
192.168.64.1    argocd.owl.com
192.168.64.1    vault.owl.com
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

## Vault UI
Root token inside root-token-vault.txt file, created during cluster creation.

```bash
open -a firefox -g https://vault.owl.com
```

## ArgoCD UI
"admin" password admin-password-argocd.txt file, created during cluster creation..

```bash
open -a firefox -g https://argocd.owl.com
```
