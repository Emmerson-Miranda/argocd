#!/bin/bash
#ifconfig | grep "192.168" 

# CREATING KIND CLUSTERS
kind create cluster --config ./kind/10-tooling-cluster.yaml
kind create cluster --config ./kind/20-ci-cluster.yaml
kind create cluster --config ./kind/30-uat-cluster.yaml
kind create cluster --config ./kind/40-prod-cluster.yaml

# DEPLOYING ARGOCD
kubectl config use-context kind-tooling-cluster
kubectl create ns argocd
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -n argocd

# changing svc to NodePort and setting ports to 30080 and 30443
kubectl patch svc argocd-server -n argocd --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"},{"op":"replace","path":"/spec/ports/0/nodePort","value":30080},{"op":"replace","path":"/spec/ports/1/nodePort","value":30443}]'

echo "Waiting for argocd-server pod to be ready $(date)"
kubectl wait po  -l app.kubernetes.io/name=argocd-server --for=condition=Ready -n argocd --timeout=60s
echo "Pod ready $(date)"


# GETTING ARGO PASSWORD
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "---------------------------------------"
echo "ArgoCD Admin pass: $argoPass"
echo "---------------------------------------"

# LOGIN in ARGO CLI
i=0
until [[ $i -gt 3  ]]
do
    argocd login --insecure --grpc-web 127.0.0.1:30443 --username admin --password $argoPass
    if [ $? -eq 0 ]; then
        echo 'Login succeeded'
        break
    else
        echo "Login $i failed, sleeping 10 secs"|
        sleep 10
    fi
done


# REGISTERING a new cluster into ARGO using CLI
# argocd cluster add kind-application-cluster -y

# REGISTERING a new cluster into ARGO DECLARATIVELY
register_cluster_in_argo(){
    context="${1}"
    echo "Registering cluster: $context"

    expr=".clusters[] | select(.name==\"$context\") | .cluster.server"
    server=$(cat ~/.kube/config | yq "$expr" | sed "s/\/\//\\\\\/\\\\\//" )

    expr=".clusters[] | select(.name==\"$context\") | .cluster.certificate-authority-data"
    caData=$(cat ~/.kube/config | yq "$expr")
    
    expr=".users[] | select(.name==\"$context\") | .user.client-certificate-data"
    certData=$(cat ~/.kube/config | yq "$expr")

    expr=".users[] | select(.name==\"$context\") | .user.client-key-data"
    keyData=$(cat ~/.kube/config | yq "$expr")
    
    cat example-11.cluster.template.yaml | \
    sed "s/PLACEHOLDER_SECRET/$context/" | \
    sed "s/PLACEHOLDER_CLUSTER_NAME/$context/" | \
    sed "s/PLACEHOLDER_SERVER/$server/" | \
    sed "s/PLACEHOLDER_CERT_DATA/$certData/" | \
    sed "s/PLACEHOLDER_KEY_DATA/$keyData/" | \
    sed "s/PLACEHOLDER_CA_DATA/$caData/" > example-11.$context.cluster.yaml
    kubectl apply -f example-11.$context.cluster.yaml
}

register_cluster_in_argo "kind-ci-cluster"
register_cluster_in_argo "kind-uat-cluster"
register_cluster_in_argo "kind-prod-cluster"


# DEPLOYING ARGO APP
# kubectl apply -f example-11.clustergenerator.yaml 
# kubectl apply -f example-11.matrixgenerator.yaml 

open -a firefox -g https://localhost:30443/settings/clusters

echo "Installation finished!"
