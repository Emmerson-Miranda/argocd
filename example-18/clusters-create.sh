#!/bin/bash
#ifconfig | grep "192.168" 

folder=$(pwd)
parent=$(dirname $folder)

source ../resources/scripts/cluster-create.sh 

# checking if argocd.owl.com is present in /etc/hosts
check_hostname argocd.owl.com
check_hostname argoworkflow.owl.com

# Creating KinD clusters
check_file_exist $folder/manifests/kind/application-cluster.yaml
kind create cluster --config $folder/manifests/kind/application-cluster.yaml
create_argo_cluster $parent/resources

# Installing ArgoCD
install_argocd $folder

# REGISTERING a new cluster into ArgoCD
param_cluster_name="kind-application-cluster"

create_argocd_secret_cluster_from_kubeconfig $parent $param_cluster_name $folder/manifests/argocd/example-18.cluster.yaml
kubectl apply -f ./manifests/argocd/example-18.cluster.yaml

# DEPLOYING ARGO APP
cat ./manifests/argocd/appproject.template.yaml   | sed "s/PLACEHOLDER_CLUSTER/$param_cluster_name/" > ./manifests/argocd/example-18.appproject.yaml
cat ./manifests/argocd/application.template.yaml  | sed "s/PLACEHOLDER_CLUSTER/$param_cluster_name/" > ./manifests/argocd/example-18.application.yaml

kubectl apply -f ./manifests/argocd/example-18.appproject.yaml  
kubectl apply -f ./manifests/argocd/example-18.application.yaml 


# DEPLOYING ARGO EVENTS and WORKFLOW
./install-argo-events-and-workflow.sh
../resources/scripts/install-argo-cli.sh

# RBAC configuration
kubectl apply -f ./manifests/k8s/argoworkflow-executor-sa.yaml 
kubectl apply -f ./manifests/k8s/read-argocd-secrets.yaml 
kubectl apply -f ./manifests/k8s/create-workflowresults.yaml 
kubectl apply -f ./manifests/k8s/delete-argocd-applications.yaml 

# Events and Workflow
kubectl apply -f ./manifests/events/cluster-deleted-in-argocd.yaml  

# Testing installation - deploying a simple workflow and checking it
argo submit ./manifests/workflow/hello-world.yaml -n argo --serviceaccount argoworkflow-executor
argo list -o wide -n argo

# Open firefox
open -a firefox -g https://argocd.owl.com/settings/clusters
open -a firefox -g https://argoworkflow.owl.com/

echo "INSTALLATION COMPLETED!!!"