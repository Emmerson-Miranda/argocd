# Introduction

Examples to deploy helmcharts.:

- [example-02.app.simple.yaml](./example-02.app.simple.yaml)  : Simple argo 'application' deploying using basic *Helm charts* without parameters and *without syncPolicy*. Uses Helm Chart source code from *git*.
- [example-02.app.multisource.yaml](./example-02.app.multisource.yaml): Multi source ArgoCD application. Deploy Prometheus helm chart using values from a different respository.


More info at: 
- https://github.com/argoproj/argocd-example-apps/tree/master/helm-guestbook
- https://argo-cd.readthedocs.io/en/latest/user-guide/multiple_sources/

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
To get the password see the output of creation script.

```bash
open -a firefox -g https://argocd.owl.com
```
