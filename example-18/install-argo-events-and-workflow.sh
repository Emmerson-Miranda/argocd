# https://argoproj.github.io/argo-events/quick_start/
# https://argo-workflows.readthedocs.io/en/latest/quick-start/

#https://github.com/argoproj/argo-workflows/releases
kubectl create namespace argo
export ARGO_WORKFLOWS_VERSION=3.6.0
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/v${ARGO_WORKFLOWS_VERSION}/install.yaml
kubectl patch deployment argo-server --patch-file ./manifests/k8s/patch-argo-server.yaml -n argo


# https://argoproj.github.io/argo-events/installation/

# namespace
kubectl create namespace argo-events

# Deploy Argo Events SA, ClusterRoles, and Controller for Sensor, EventBus, and EventSource.
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml

# Install with a validating admission controller
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install-validating-webhook.yaml

# Deploy the eventbus.
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml


# https://argoproj.github.io/argo-events/validating-admission-webhook/

#Validating Admission Webhook 
# v1.9.2 https://github.com/argoproj/argo-events/releases/tag/v1.9.2
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/v1.9.2/manifests/install-validating-webhook.yaml


## INSTALLING THE EXAMPLE
#kubectl apply -f example-18-event-source-resources.yaml 

## INSTALLING Ingress Controller
kubectl apply -f manifests/k8s/argoworflow-ingress.yaml
