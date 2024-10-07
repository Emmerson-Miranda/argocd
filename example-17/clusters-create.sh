#!/bin/bash
folder=$(pwd)
parent=$(dirname $folder)

source ../resources/scripts/cluster-create.sh 

create_argo_cluster $parent/resources

install_argocd $folder

# argocd login --insecure --grpc-web argocd.owl.com --username admin --password $argoPass 

echo "Installation finished!"