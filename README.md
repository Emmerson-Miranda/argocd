# ArgoCD
ArgoCD examples, latest test with "Version": "v2.9.0+4e084ac"

ArgoCD Application CRD https://argoproj.github.io/argo-cd/operator-manual/application.yaml


## Installation

https://argo-cd.readthedocs.io/en/release-2.0/getting_started/

## Minikube Installation

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
http://127.0.0.1:53208
http://127.0.0.1:53209
❗  Because you are using a Docker driver on darwin, the terminal needs to be open to run it.
```

Admin password

```bash
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo $argoPass
```

Login

```bash
$ argocd login --insecure --grpc-web 127.0.0.1:53208 --username admin --password $argoPass
'admin:login' logged in successfully
Context '127.0.0.1:53208' updated
$
```
