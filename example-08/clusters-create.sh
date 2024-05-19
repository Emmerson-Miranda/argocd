#!/bin/bash
folder=$(pwd)
parent=$(dirname $folder)

source ../resources/scripts/cluster-create.sh 

create_argo_cluster $parent/resources

install_argocd $parent/resources

kubectl apply -f ./example-08.appset.yaml 

echo "Installation finished!"