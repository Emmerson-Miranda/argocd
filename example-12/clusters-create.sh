#!/bin/bash
#ifconfig | grep "192.168" 

# CREATING CLUSTER 
kind create cluster --config ./kind/argocd-cluster-12.yaml
sleep 5
# DEPLOYING Ingress
kubectl apply -f ./nginx-ingress/nginx-ingress-kind-deploy.yaml
sleep 5
echo "Waiting for ingress-nginx pod to be ready $(date)"
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
echo "Ingress-nginx pod ready $(date)"

# CREATING NAMESPACE
kubectl create ns argocd


# DEPLOYING OpenLDAP
kubectl apply -f ./openldap/deployment-ldap.yml -n argocd
sleep 5
echo "Waiting for openldap pod to be ready $(date)"
kubectl wait po  -l app.kubernetes.io/name=openldap --for=condition=Ready -n argocd --timeout=60s
echo "OpenLDAP Pod ready $(date)"


# DEPLOYING ArgoCD
#kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -n argocd
kubectl apply -f argocd/install-argocd.yaml -n argocd
sleep 5
echo "Waiting for argocd-server pod to be ready $(date)"
kubectl wait po  -l app.kubernetes.io/name=argocd-server --for=condition=Ready -n argocd --timeout=60s
echo "ArgoCD Server Pod ready $(date)"


# GETTING ARGO PASSWORD
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "---------------------------------------"
echo "ArgoCD Admin pass: $argoPass"
echo "---------------------------------------"

# Configuring ingress
kubectl apply -f nginx-ingress/ingress-phpldapadmin.yaml -n argocd
kubectl apply -f nginx-ingress/ingress-argocd.yaml -n argocd
# open https://phpldapadmin.owl.com
# open https://argocd.owl.com

echo "Installation finished!"

# patch argocd
#https://argo-cd.readthedocs.io/en/stable/operator-manual/user-management/#dex
#https://www.opsmx.com/blog/how-to-setup-ldap-and-openldap-for-argocd/
# kubectl -n argocd patch configmaps argocd-cm --patch "$(cat argocd/patch-dex.yaml)"
# kubectl -n argocd patch secrets argocd-secret --patch "{\"data\":{\"dex.ldap.bindPW\":\"$(echo XXPASWDXXXXX | base64 -w 0)\"}}"
# kubectl -n argocd patch secrets argocd-secret --patch "{\"data\":{\"dex.ldap.bindDN\":\"$(echo cn=XXXXXX,dc=opsmx,dc=com | base64 -w 0)\"}}"

# kubectl delete po -l app.kubernetes.io/name=argocd-server  -n argocd
# kubectl delete po -l app.kubernetes.io/name=argocd-dex-server  -n argocd
