# ArgoCD
ArgoCD examples, latest test with "Version": "v2.9.0+4e084ac"

ArgoCD Application CRD https://argoproj.github.io/argo-cd/operator-manual/application.yaml


## Installation

https://argo-cd.readthedocs.io/en/release-2.0/getting_started/

Installation

```bash
kubectl create ns argocd
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -n argocd
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

Admin password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o json | jq .data.password -r | base64 -d
```

