#!/bin/bash
#ifconfig | grep "192.168" 

# CREATING CLUSTER 
kind create cluster --config ./kind/argocd-cluster-13.yaml

# deploying ingress
kubectl apply -f ./kind/nginx-ingress-kind-deploy.yaml
sleep 15
echo "Waiting for ingress-nginx pod to be ready $(date)"
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
echo "Ingress-nginx pod ready $(date)"

# INSTALL HASHICORP VAULT
helm repo add hashicorp https://helm.releases.hashicorp.com
helm upgrade vault hashicorp/vault -i -n vault -f values/hashicorp-vault-values.yaml --create-namespace
sleep 15
kubectl wait po  -l app.kubernetes.io/name=vault --for=condition=Ready -n vault --timeout=60s

kubectl -n vault exec vault-0 -- vault operator init > ./tmp/vault-operator-init.txt
key1=$(cat ./tmp/vault-operator-init.txt | grep "Unseal Key 1" | cut -d' ' -f4-)
key2=$(cat ./tmp/vault-operator-init.txt | grep "Unseal Key 2" | cut -d' ' -f4-)
key3=$(cat ./tmp/vault-operator-init.txt | grep "Unseal Key 3" | cut -d' ' -f4-)
roottoken=$(cat ./tmp/vault-operator-init.txt | grep "Initial Root Token:" | cut -d' ' -f4-)
echo $roottoken > ./tmp/root-token-vault.txt

kubectl -n vault exec vault-0 -- vault operator unseal $key1 
kubectl -n vault exec vault-0 -- vault operator unseal $key2
kubectl -n vault exec vault-0 -- vault operator unseal $key3
kubectl -n vault exec vault-0 -- vault login $roottoken

kubectl -n vault exec vault-0 -- vault secrets enable kv-v2
kubectl -n vault exec vault-0 -- vault secrets list
kubectl -n vault exec vault-0 -- vault kv put kv-v2/my-secrets/secret1 username=emmerson password=mypassword


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
