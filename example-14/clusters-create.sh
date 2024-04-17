#!/bin/bash
#ifconfig | grep "192.168" 

# CREATING CLUSTER 
kind create cluster --config ./kind/argocd-cluster-14.yaml

# deploying ingress
kubectl apply -f ./kind/nginx-ingress-kind-deploy.yaml
sleep 15
echo "Waiting for ingress-nginx pod to be ready $(date)"
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
echo "Ingress-nginx pod ready $(date)"

# INSTALL ArgoCD
cat ./values/argo-cd-values.yaml | sed "s/VAULT_TOKEN_PLACEHOLDER/$roottoken/" > ./tmp/argo-cd-values.yaml 

helm repo add argo-cd https://argoproj.github.io/argo-helm
helm upgrade argocd argo-cd/argo-cd -i -n argocd -f tmp/argo-cd-values.yaml --create-namespace
sleep 15
kubectl wait po  -l app.kubernetes.io/name=argocd-server --for=condition=Ready -n argocd --timeout=60s

argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "---------------------------------------"
echo "ArgoCD Admin pass: $argoPass"
echo "---------------------------------------"
echo $argoPass > ./tmp/admin-password-argocd.txt

echo "Installation finished!"
