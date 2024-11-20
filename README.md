# ArgoCD Examples 

ArgoCD examples, starting from most basic to medium complexity.

ArgoCD Application CRD https://argoproj.github.io/argo-cd/operator-manual/application.yaml

List of examples:

| Example | Description                                            |
|-----|--------------------------------------------------------|
| [01](./example-01/readme.md) | Simple argo *Application* deploying using *basic k8s manifests*.               |
| [02](./example-02/readme.md) | Simple argo *Application* deploying using basic *Helm charts* without parameters and *without syncPolicy*. <br/>Uses Helm Chart source code from *git*.              |
| [03](./example-03/readme.md) | Simple argo *Application* deploying using basic *Helm charts* without parameters and *with syncPolicy*. <br/>Uses Helm Chart source code from *git*.    |
| [04](./example-04/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, static *list generator*, basic *Helm charts* with *values* and *with syncPolicy*. <br/>Uses Helm Chart source code from *git*.   |
| [05](./example-05/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *values* and *with syncPolicy*. <br/>Uses Helm Chart source code from *git*.   |
| [06](./example-06/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *values* and *with syncPolicy*. <br/>Uses Helm Chart source code from *git*. Overrides parameters per environment.   |
| [07](./example-07/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *file values* and *with syncPolicy*. <br/>Uses Helm Chart source code from *git*. Inject values into chart from a Git repo.  |
| [08](./example-08/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *file values* and *with syncPolicy*. <br/>Uses Helm Chart source code from *git*. Inject values into chart from an *https source*.   |
| [09](./example-09/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, use external *Helm chart*(wiremock) with *file values* and *with syncPolicy*. <br/>Inject values into chart from a Git repo.   |
| [10](./example-10/readme.md) | Based on example [01](./example-01/readme.md) . Deploy into a *remote cluster*. Register *cluster* and creates a *new project declaratively*. <br/>This example create two K8S clusters with *KinD*.  |
| [11](./example-11/readme.md) | Based on example [10](./example-10/readme.md) . More advanced example were argo deploy dinamically in multiple applications in multiple clusters using selectors to exclude applications and clusters.  |
| [12](./example-12/readme.md) | (WIP) Integrate ArgoCD with OpenLDAP.  |
| [13](./example-13/readme.md) | Integrate ArgoCD with Hashicorp Vault using sidecar option and simple manifests.  |
| [14](./example-14/readme.md) | App of Apps with helmcharts  |
| [15](./example-15/readme.md) | (WIP) Integrate ArgoCD with Hashicorp Vault using Helm Plugin and replacing secrets in values files.  |
| [16](./example-16/readme.md) | Create and configure local users.  |
| [18](./example-18/readme.md) | Argo ecosystem integration (CD, Event, Workflow). |


## /etc/hosts
Add argocd.owl.com DNS entry in your /etc/hosts file.

```bash
192.168.64.1    argocd.owl.com
```

## ArgoCD Installation in KinD

Each example has a create and destroy script.

## Argocd CLI login

To download CLI follow instructions here https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli


### Login

```bash
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo $argoPass
argocd login --insecure --grpc-web argocd.owl.com --username admin --password $argoPass 
```

