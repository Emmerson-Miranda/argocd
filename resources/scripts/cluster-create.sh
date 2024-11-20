#!/bin/bash

#param_argocd_manifest="$2"

#argocd_manifest="${param_argocd_manifest:-$basefolder/resources/kind/argocd-values.yaml}"


# Check if a hostname is in /etc/hosts
function check_hostname(){
    param_hostname="$1"
    cat /etc/hosts | grep $param_hostname
    if [ $? -eq 0 ]; then
        echo 'argocd.owl.com present in /etc/hosts'
    else
        echo "*********************************************************************************"
        echo "ERROR: Pre-requisite not satisfied!"
        echo "Add the hostname $param_hostname in /etc/hosts pointing out to your IP 192.168.x.y"
        echo "*********************************************************************************"
        exit -1
    fi
}

# Create a KinD cluster to deploy ArgoCD
function create_argo_cluster(){
    echo "------------------------ create_argo_cluster ---------------------------------------------------"
    echo "------------------------------------------------------------------------------------------------"
    cluster=$(kubectl config current-context)
    cluster_name_expected="kind-argocd-cluster"
    if [ "$cluster" = "$cluster_name_expected" ]; then
        echo "Cluster $cluster already present."
        return
    else
        echo "Creating KinD cluster."
    fi

    param_folder="$1"
    currentfolder=$(pwd)
    basefolder="${param_folder:-$currentfolder}"
    echo "KinD configuration base folder: $basefolder"

    #create KinD cluster
    kind create cluster --config $basefolder/kind/argocd-cluster.yaml

    # Deploying KinD ingress
    kubectl apply -f $basefolder/kind/nginx-ingress-kind-deploy.yaml
    sleep 15
    echo "Waiting for ingress-nginx pod to be ready $(date)"
    kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s
    echo "Ingress-nginx pod ready $(date)"
}


# Install ArgoCD
function install_argocd(){
    echo "---------------------- install_argocd -----------------------------------------------------"
    echo "-------------------------------------------------------------------------------------------"
    argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    if [ "$argoPass" != "" ]; then
        echo "ArgoCD already present. Admin pass: $argoPass"
        return
    else
        echo "Deploying ArgoCD ..."
    fi
      
    param_folder="$1"
    currentfolder=$(pwd)
    basefolder="${param_folder:-$currentfolder}"
    echo "ArgoCD configuration base folder: $basefolder"

    helm repo add argo-cd https://argoproj.github.io/argo-helm
    helm upgrade argocd argo-cd/argo-cd -i -n argocd -f $basefolder/values/argocd-values.yaml --create-namespace
    sleep 15
    kubectl wait po  -l app.kubernetes.io/name=argocd-server --for=condition=Ready -n argocd --timeout=60s

    argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    echo "---------------------------------------"
    echo "ArgoCD Admin pass: $argoPass"
    echo "---------------------------------------"
    mkdir -p $basefolder/tmp
    echo $argoPass > $basefolder/tmp/admin-password-argocd.txt

    # LOGIN in ARGO CLI
    i=0
    until [[ $i -gt 6  ]]
    do
        argocd login --insecure --grpc-web argocd.owl.com --username admin --password $argoPass
        if [ $? -eq 0 ]; then
            echo 'Login succeeded'
            break
        else
            echo "Login $i failed, sleeping 5 secs"|
            sleep 5
        fi
    done
}


function install_hashicorp_vault(){
    echo "--------------------- install_hashicorp_vault ------------------------------------------------------"
    echo "----------------------------------------------------------------------------------------------------"
    param_folder="$1"
    currentfolder=$(pwd)
    basefolder="${param_folder:-$currentfolder}"
    mkdir -p $basefolder
    #echo "Base folder: $basefolder"

    phase=$(kubectl -n vault get po vault-0 -o=jsonpath={.status.phase})
    if [ "$phase" = "Running" ]; then
        roottoken=$(cat $basefolder/tmp/root-token-vault.txt)
        #echo "Hashicorp Vault already present. Admin Token: $roottoken"
        echo $roottoken
    else
        #echo "Deploying Hashicorp Vault ..."

        helm repo add hashicorp https://helm.releases.hashicorp.com
        helm upgrade vault hashicorp/vault -i -n vault -f $basefolder/values/hashicorp-vault-values.yaml --create-namespace
        sleep 15
        kubectl wait po  -l app.kubernetes.io/name=vault --for=condition=Ready -n vault --timeout=60s

        kubectl -n vault exec vault-0 -- vault operator init > $basefolder/tmp/vault-operator-init.txt
        key1=$(cat $basefolder/tmp/vault-operator-init.txt | grep "Unseal Key 1" | cut -d' ' -f4-)
        key2=$(cat $basefolder/tmp/vault-operator-init.txt | grep "Unseal Key 2" | cut -d' ' -f4-)
        key3=$(cat $basefolder/tmp/vault-operator-init.txt | grep "Unseal Key 3" | cut -d' ' -f4-)
        roottoken=$(cat $basefolder/tmp/vault-operator-init.txt | grep "Initial Root Token:" | cut -d' ' -f4-)
        echo $roottoken > $basefolder/tmp/root-token-vault.txt

        kubectl -n vault exec vault-0 -- vault operator unseal $key1 
        kubectl -n vault exec vault-0 -- vault operator unseal $key2
        kubectl -n vault exec vault-0 -- vault operator unseal $key3
        kubectl -n vault exec vault-0 -- vault login $roottoken

        kubectl -n vault exec vault-0 -- vault secrets enable kv-v2
        kubectl -n vault exec vault-0 -- vault secrets list
        kubectl -n vault exec vault-0 -- vault kv put kv-v2/my-secrets/secret1 username=emmerson1 password=mypassword1
        kubectl -n vault exec vault-0 -- vault kv put kv-v2/my-secrets/secret2 username=emmerson2 password=mypassword2
        kubectl -n vault exec vault-0 -- vault kv put kv-v2/my-secrets/secret3 username=emmerson3 password=mypassword3
        echo $roottoken
    fi
}
