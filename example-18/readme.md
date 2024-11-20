# Introduction
Based on example [01](./example-01/readme.md) deploy simple applications from a directory. 
- This example create two K8S clusters with *KinD*.
- Install:
  - ArgoCD
  - Argo Events
  - Argo Workflow
- Register *a remote cluster* declaratively* in ArgoCD. 
- Deploy applications into a *remote cluster* with ArgoCD. 

ArgoCD cluster registration is just a secret, when a cluster is removed from ArgoCD, all applications remain orphans waiting until the cluster is restored. 
This PoC also configure *Argo Events* to listen events when the secret is modified or deleted, then it trigger an Argo Worflow to delete the orphan applications.
- One event source listening changes in kubernetes
- Two worflows
  - Print the cluster that trigger the action
  - Clean up ArgoCD applications


## Installation instructions

Install ArgoCD CLI, see [Instructions here](../README.md)

```bash
./clusters-create.sh
```

After installation finish, open your browser below links:
* https://argocd.owl.com/
* https://argoworkflow.owl.com/

## Deleting everything

```bash
./clusters-destroy.sh
```

## How to trigger deletion wokflow

There are three ways to trigger the workflow:
1) Deleting the secret from command line

```bash
kubectl -n argocd delete secret mycluster-secret 
```

2) modifying the secret from command line
```bash
kubectl -n argocd label secret mycluster-secret a=1
```

3) Deleting the cluster using ArgoCD UI (Settings -> Clusters -> three dots -> Delete)

## Screenshots

**ArgoCD - clusters**
![List of clusters registered in Argo](./img/clusters.png)

**ArgoCD - application**
![Application deployed](./img/application.png)

**Argo Workflow - before trigger deletion**
![Argo Workflow - before trigger deletion](./img/argoworkflow-before.png)

**Argo Workflow - After trigger deletion**
![Argo Workflow - after trigger deletion](./img/argoworkflow-after.png)

**Argo Workflow - logs**
![Argo Workflow - Log print task](./img/log-print.png)

![Argo Workflow - Log cleanup task](./img/log-cleanup.png)
