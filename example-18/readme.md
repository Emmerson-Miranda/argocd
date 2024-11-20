# Introduction
Based on example [01](./example-01/readme.md) . Deploy into a *remote cluster*. Register *cluster* and creates a *new project declaratively*. This example create two K8S clusters with *KinD*.

This example deploy Argo Events and Argo Workflow.

- Create two kubernetes cluster using KinD (argocd-cluster and application-cluster)

```
kubectl config get-contexts
CURRENT   NAME                       CLUSTER                    AUTHINFO                   NAMESPACE
          kind-application-cluster   kind-application-cluster   kind-application-cluster   
*         kind-argocd-cluster        kind-argocd-cluster        kind-argocd-cluster   
```

- Register a kubernetes cluster in ArgoCD using Kubernetes Secret
![New cluster in ArgoCD registred](./img/clusters.png)

- The application example-18 in deployed in application-cluster.f
![Example 10 deployed](./img/application.png)

- Register declaratively a new project in Argo called "my-project"


## Installation instructions

Install ArgoCD CLI, see [Instructions here](../README.md)

```bash
./clusters-create.sh
```

Open your browser in two Argo hosts:
* https://argocd.owl.com/
* https://argoworkflow.owl.com/

## Deleting everything

```bash
./clusters-destroy.sh
```
