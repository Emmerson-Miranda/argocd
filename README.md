# ArgoCD Examples "v2.9.0+4e084ac"
ArgoCD examples, starting from most basic to medium complexity.

ArgoCD Application CRD https://argoproj.github.io/argo-cd/operator-manual/application.yaml

List of examples:

Examples from 01 to 09 uses Minikube. Example 10 uses KinD.

| Example | Description                                            |
|-----|--------------------------------------------------------|
| [01](./example-01/readme.md) | Simple argo *Application* deploying using *basic k8s manifests*.               |
| [02](./example-02/readme.md) | Simple argo *Application* deploying using basic *Helm charts* without parameters and *without syncPolicy*. Uses Helm Chart source code from *git*.              |
| [03](./example-03/readme.md) | Simple argo *Application* deploying using basic *Helm charts* without parameters and *with syncPolicy*. Uses Helm Chart source code from *git*.    |
| [04](./example-04/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, static *list generator*, basic *Helm charts* with *values* and *with syncPolicy*. Uses Helm Chart source code from *git*.   |
| [05](./example-05/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *values* and *with syncPolicy*. Uses Helm Chart source code from *git*.   |
| [06](./example-06/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *values* and *with syncPolicy*. Uses Helm Chart source code from *git*. Overrides parameters per environment.   |
| [07](./example-07/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *file values* and *with syncPolicy*. Uses Helm Chart source code from *git*. Inject values into chart from a Git repo.  |
| [08](./example-08/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, basic *Helm charts* with *file values* and *with syncPolicy*. Uses Helm Chart source code from *git*. Inject values into chart from an *https source*.   |
| [09](./example-09/readme.md) | Deploy in multiple environments. Uses *ApplicationSet*, dynamic *git generator*, use external *Helm chart*(wiremock) with *file values* and *with syncPolicy*. Inject values into chart from a Git repo.   |
| [10](./example-10/readme.md) | Based on example [01](./example-01/readme.md) . Deploy into a *remote cluster*. Register *cluster using CLI* and creates a *new project declaratively*. This example create two K8S clusters with *KinD*.  |


## Installation

https://argo-cd.readthedocs.io/en/release-2.0/getting_started/

## Starting Minikube clusters

```bash
#minikube that contains ArgoCD installed
minikube start --network default
#target cluster to deploy
minikube start -p othercluster --network default
```

## ArgoCD Installation in Minikube

```bash
kubectl create ns argocd
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -n argocd
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Argocd CLI login

To download CLI follow instructions here https://argo-cd.readthedocs.io/en/stable/getting_started/#2-download-argo-cd-cli

Open a new console to run the service
```bash
minikube  service argocd-server -n argocd --url
```
```
http://127.0.0.1:53208
http://127.0.0.1:53209
❗  Because you are using a Docker driver on darwin, the terminal needs to be open to run it.
```

Login

```bash
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo $argoPass
argocd login --insecure --grpc-web 127.0.0.1:53208 --username admin --password $argoPass
```
```
'admin:login' logged in successfully
Context '127.0.0.1:53208' updated
```
