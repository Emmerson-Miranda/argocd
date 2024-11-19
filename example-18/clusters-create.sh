#!/bin/bash
#ifconfig | grep "192.168" 

# CREATING KIND CLUSTERS
kind create cluster --config ./kind/application-cluster.yaml
kind create cluster --config ./kind/argocd-cluster.yaml

# DEPLOYING ARGOCD
kubectl create ns argocd
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -n argocd

# changing svc to NodePort and setting ports to 30080 and 30443
kubectl patch svc argocd-server -n argocd --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"},{"op":"replace","path":"/spec/ports/0/nodePort","value":30080},{"op":"replace","path":"/spec/ports/1/nodePort","value":30443}]'

echo "Waiting for argocd-server pod to be ready $(date)"
sleep 10
kubectl wait po  -l app.kubernetes.io/name=argocd-server --for=condition=Ready -n argocd
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
caData=$(cat ~/.kube/config | yq '.clusters[] | select(.name=="kind-application-cluster") | .cluster.certificate-authority-data')
#echo $caData
certData=$(cat ~/.kube/config | yq '.users[] | select(.name=="kind-application-cluster") | .user.client-certificate-data')
#echo $certData
keyData=$(cat ~/.kube/config | yq '.users[] | select(.name=="kind-application-cluster") | .user.client-key-data')
#echo $keyData
cat example-18.cluster.template | sed "s/PLACEHOLDER_CERT_DATA/$certData/"  | sed "s/PLACEHOLDER_KEY_DATA/$keyData/"  | sed "s/PLACEHOLDER_CA_DATA/$caData/" > example-18.cluster.yaml
kubectl apply -f example-18.cluster.yaml

# CREATING A NEW ARGO PROJECT DECLARATIVELY
kubectl apply -f example-18.appproject.yaml  

# DEPLOYING ARGO APP
kubectl apply -f example-18.application.yaml 

open -a firefox -g https://localhost:30443/settings/clusters

echo "Installation finished!"
