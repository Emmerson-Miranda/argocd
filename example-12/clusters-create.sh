#!/bin/bash
#ifconfig | grep "192.168" 

# KEYCLOACK 
KEYCLOACK_IP=192.168.64.1
kind create cluster --config ./kind/argocd-cluster-12.yaml

# OpenLDAP
kubectl apply -f ./openldap/deployment-ldap.yml


#  ARGOCD
Pending


echo "Installation finished!"
