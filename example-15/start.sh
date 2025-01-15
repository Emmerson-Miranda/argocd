#!/bin/bash
folder=$(pwd)
parent=$(dirname $folder)

source ../resources/scripts/cluster-create.sh 

create_argo_cluster $parent/resources/kind

roottoken=$(install_hashicorp_vault $parent/resources)

install_argocd $parent/resources

sleep 15
kubectl apply -f ./example-15.helmchart.app.yaml 
sleep 15
source ./list-secrets.sh
echo "Installation finished! $roottoken"