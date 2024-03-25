# Introduction (Work in progress)
Integrate ArgoCD with OpenLDAP.

## etc/hosts

```bash
192.168.64.1    argocd.owl.com
192.168.64.1    phpldapadmin.owl.com
```

## Installation

```bash
./clusters-create.sh
```

## OpenLDAP UI
Username and Password are environment variables:
- LDAP_ADMIN_DN
- LDAP_ADMIN_PASSWORD

```bash
open -a firefox -g https://phpldapadmin.owl.com
```

## ArgoCD UI

```bash
open -a firefox -g https://argocd.owl.com
```
