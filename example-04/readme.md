# Introduction
Deploy in multiple environments. Uses *ApplicationSet*, static *list generator*, basic *Helm charts* with *values* and *with syncPolicy*. Uses Helm Chart source code from *git*.

![Appplications created by the applicationset](example-04.png)

More info at: 
- https://argo-cd.readthedocs.io/en/stable/user-guide/application-set/
- https://argo-cd.readthedocs.io/en/stable/user-guide/helm/
- https://argocd-applicationset.readthedocs.io/en/stable/Generators/
- https://argo-cd.readthedocs.io/en/stable/user-guide/sync-options/
- https://github.com/argoproj/argocd-example-apps/tree/master/helm-guestbook
- https://amralaayassen.medium.com/how-to-create-argocd-applications-automatically-using-applicationset-automation-of-the-gitops-59455eaf4f72



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
