#!/bin/bash
folder=$(pwd)
parent=$(dirname $folder)

source ../resources/scripts/cluster-create.sh 

create_argo_cluster $parent/resources

install_argocd $parent/resources

kubectl apply -f ./app-of-apps/app/example-14.parent.yaml

echo "Installation finished!"