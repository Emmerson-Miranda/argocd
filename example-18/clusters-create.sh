#!/bin/bash
#ifconfig | grep "192.168" 

folder=$(pwd)
parent=$(dirname $folder)

source ../resources/scripts/cluster-create.sh 

# checking if argocd.owl.com is present in /etc/hosts
check_hostname argocd.owl.com
check_hostname argoworkflow.owl.com

# Creating clusters
kind create cluster --config ./kind/application-cluster.yaml
create_argo_cluster $parent/resources

install_argocd $folder


# REGISTERING a new cluster into ARGO using CLI
# argocd cluster add kind-application-cluster -y

# REGISTERING a new cluster into ARGO DECLARATIVELY
caData=$(cat ~/.kube/config | yq '.clusters[] | select(.name=="kind-application-cluster") | .cluster.certificate-authority-data')
certData=$(cat ~/.kube/config | yq '.users[] | select(.name=="kind-application-cluster") | .user.client-certificate-data')
keyData=$(cat ~/.kube/config | yq '.users[] | select(.name=="kind-application-cluster") | .user.client-key-data')
cat example-18.cluster.template | sed "s/PLACEHOLDER_CERT_DATA/$certData/"  | sed "s/PLACEHOLDER_KEY_DATA/$keyData/"  | sed "s/PLACEHOLDER_CA_DATA/$caData/" > example-18.cluster.yaml
kubectl apply -f example-18.cluster.yaml

# CREATING A NEW ARGO PROJECT DECLARATIVELY
kubectl apply -f example-18.appproject.yaml  

# DEPLOYING ARGO APP
kubectl apply -f example-18.application.yaml 

open -a firefox -g https://argocd.owl.com/settings/clusters

echo "ArgoCD Installed with two clusters!"

./install-argo-events-and-workflow.sh

open -a firefox -g https://argoworkflow.owl.com/

echo "Argo Events and Argo Workflow installed!"