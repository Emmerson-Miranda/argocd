# Introduction (Work in progress)
Basic user management using local users. 
- Disable root user
- Create users: adminuser, devops and devuser.
- Set Myu7UVI2TggfBlKJ as password for all users
- Assign policies with different roles for all users.

## Cluster creation and destroy

Creation
```bash
./clusters-create.sh
```

Destroy
```bash
./clusters-destroy.sh
```

## User creation

The password used in this example is "Myu7UVI2TggfBlKJ", in the values you should put the bcrypt hash value, to generate the bash you can use ArgoCD CLI.

```bash
argocd account bcrypt --password Myu7UVI2TggfBlKJ
```

Below script define three users that can login into UI and can generate tokens: adminuser, devops and devuser.

```yaml
configs:
  secret:
    extra:
      # argocd account bcrypt --password Myu7UVI2TggfBlKJ
      accounts.devuser.password: $2a$10$mTHfPGI8aOKxf7QjZRddG.18D9aywpSL1lwsQmpun0luU3QITJCW.
      accounts.devops.password: $2a$10$mTHfPGI8aOKxf7QjZRddG.18D9aywpSL1lwsQmpun0luU3QITJCW.
      accounts.adminuser.password: $2a$10$mTHfPGI8aOKxf7QjZRddG.18D9aywpSL1lwsQmpun0luU3QITJCW.
  cm:
    admin.enabled: "false"
    accounts.devuser: apiKey, login
    accounts.devops: apiKey, login
    accounts.adminuser: apiKey, login

  rbac:
    policy.csv: |
      p, role:org-devops, applications, *, */*, allow
      p, role:org-devops, clusters, *, *, allow
      p, role:org-devops, repositories, *, *, allow
      p, role:org-devops, logs, *, *, allow
      p, role:org-devops, exec, *, */*, allow
      p, role:org-dev, applications, *, */*, allow
      g, adminuser, role:admin
      g, devops, role:org-devops
      g, devuser, role:org-dev
```
For more info see: [RBAC Configuration](https://argo-cd.readthedocs.io/en/stable/operator-manual/rbac/)

## ArgoCD UI
Use one of the users previously mentioned.

```bash
open -a firefox -g https://argocd.owl.com
```
