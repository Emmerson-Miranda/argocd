# Introduction
Based on example [01](./example-01/readme.md) . Deploy into a *remote cluster*. Register *cluster* and creates a *new project declaratively*. This example create two K8S clusters with *KinD*.

- Create two kubernetes cluster using KinD (argocd-cluster and application-cluster)

```
kubectl config get-contexts
CURRENT   NAME                       CLUSTER                    AUTHINFO                   NAMESPACE
          kind-application-cluster   kind-application-cluster   kind-application-cluster   
*         kind-argocd-cluster        kind-argocd-cluster        kind-argocd-cluster   
```

- Deploy ArgoCD in argocd-cluster

```
kubectl get po -n argocd -o wide
NAME                                                READY   STATUS    RESTARTS   AGE   IP           NODE                    NOMINATED NODE   READINESS GATES
argocd-application-controller-0                     1/1     Running   0          19m   10.244.1.8   argocd-cluster-worker   <none>           <none>
argocd-applicationset-controller-56c959df55-jr4bk   1/1     Running   0          19m   10.244.1.2   argocd-cluster-worker   <none>           <none>
argocd-dex-server-5f77c4fbc9-sldhm                  1/1     Running   0          19m   10.244.1.5   argocd-cluster-worker   <none>           <none>
argocd-notifications-controller-5f94cb7845-7w2m9    1/1     Running   0          19m   10.244.1.3   argocd-cluster-worker   <none>           <none>
argocd-redis-76748db5f4-4gp4l                       1/1     Running   0          19m   10.244.1.4   argocd-cluster-worker   <none>           <none>
argocd-repo-server-f7646b949-pgpcq                  1/1     Running   0          19m   10.244.1.7   argocd-cluster-worker   <none>           <none>
argocd-server-79bbfb8ffc-r5kxf                      1/1     Running   0          19m   10.244.1.6   argocd-cluster-worker   <none>           <none>
```

- Register a kubernetes cluster in ArgoCD using argocd CLI
![New cluster in ArgoCD registred](./img/clusters.png)

- Register declaratively a new project in Argo called "my-project"
![New project in ArgoCD registred](./img/projects.png)

- The application example-10 in deployed in application-cluster.
![Example 10 deployed](./img/application.png)

```
kubectl get po -n example-10 -o wide
NAME                                  READY   STATUS    RESTARTS   AGE     IP           NODE                         NOMINATED NODE   READINESS GATES
busybox-deployment-86c4c67f86-czjz2   1/1     Running   0          3m38s   10.244.1.3   application-cluster-worker   <none>           <none>
upstream-deployment-7fdbf9974-w7sgn   1/1     Running   0          3m38s   10.244.1.2   application-cluster-worker   <none>           <none>
```

## Installation instructions

Install ArgoCD CLI, see [Instructions here](../README.md)

Script will use 30080 and 30443 ports on your localhost.

```bash
./clusters-create.sh
```


## Deleting everything

```bash
./clusters-destroy.sh
```


## ArgoCD in External cluster

When register a new cluster in ArgoCD it connects to it and generate following objects by default.

**ServiceAccount argocd-manager**

```bash
kubectl get sa argocd-manager -o yaml -n kube-system

apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2024-02-11T09:57:34Z"
  name: argocd-manager
  namespace: kube-system
  resourceVersion: "653"
  uid: 3dabe7d7-798d-4040-abde-755aaadfa2e2
secrets:
- name: argocd-manager-token-8t8m9
```

***Secret argocd-manager-token-8t8m9***

```bash
kubectl get secret  argocd-manager-token-8t8m9 -o yaml -n kube-system

apiVersion: v1
data:
  ca.crt: LS0t... client-certificate-data inside kubeconfig file ...FLS0tLS0K
  namespace: a3ViZS1zeXN0ZW0=   # kube-system
  token: ZXlKa...zUXFveXc=
kind: Secret
metadata:
  annotations:
    kubernetes.io/service-account.name: argocd-manager
    kubernetes.io/service-account.uid: 3dabe7d7-798d-4040-abde-755aaadfa2e2
  creationTimestamp: "2024-02-11T09:57:39Z"
  generateName: argocd-manager-token-
  name: argocd-manager-token-8t8m9
  namespace: kube-system
  resourceVersion: "654"
  uid: 689c94ac-f107-4bd7-ad72-4ec6d78cdf79
type: kubernetes.io/service-account-token
```

**ClusterRole argocd-manager-role**

```bash
kubectl get ClusterRole argocd-manager-role -o yaml

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  creationTimestamp: "2024-02-11T09:57:34Z"
  name: argocd-manager-role
  resourceVersion: "642"
  uid: 6ac20f76-1f8d-40f1-ba35-e07cbea95b53
rules:
- apiGroups:
  - '*'
  resources:
  - '*'
  verbs:
  - '*'
- nonResourceURLs:
  - '*'
  verbs:
  - '*'
```

**ClusterRoleBinding argocd-manager-role-binding**

```bash
kubectl get ClusterRoleBinding argocd-manager-role-binding -o yaml

apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  creationTimestamp: "2024-02-11T09:57:34Z"
  name: argocd-manager-role-binding
  resourceVersion: "643"
  uid: 654f4c0a-083a-43f8-922c-9bc9e915b866
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: argocd-manager-role
subjects:
- kind: ServiceAccount
  name: argocd-manager
  namespace: kube-system
```

### On ArgoCD cluster
ArgoCD create a secret per cluster to store the credentials to access to external cluster. 

```bash
kubectl get secrets "cluster-192.168.64.1-2102044685"  -n argocd -o yaml

apiVersion: v1
data:
  config: ... base64 encoded ...                # text explained in the next section
  name: a2luZC1hcHBsaWNhdGlvbi1jbHVzdGVy        # kind-application-cluster
  server: aHR0cHM6Ly8xOTIuMTY4LjY0LjE6ODQ0Mw==  # https://192.168.64.1:8443
kind: Secret
metadata:
  annotations:
    managed-by: argocd.argoproj.io
  creationTimestamp: "2024-02-11T09:57:40Z"
  labels:
    argocd.argoproj.io/secret-type: cluster
  name: cluster-192.168.64.1-2102044685
  namespace: argocd
  resourceVersion: "885"
  uid: 3cd9fae0-b284-494a-92ae-d3c91addde9f
type: Opaque
```

**The data.config explained**

Is a json value base64 encoded with following relevant properties:
- certData : Is *client-certificate-data* as-is inside *kubeconfig* for *kind-application-cluster*.
- keyData : Is *client-key-data* as-is inside *kubeconfig* for *kind-application-cluster*.
- caData: Is *certificate-authority-data* as-is inside *kubeconfig* for *kind-application-cluster*.

```bash
kubectl get secrets "cluster-192.168.64.1-2102044685"  -n argocd -o yaml | yq .data.config | base64 -d

{"tlsClientConfig":{"insecure":false,"certData":"...","keyData":"...","caData":"..."}}
```
