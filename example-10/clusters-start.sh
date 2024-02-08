#!/bin/bash
#ifconfig | grep "192.168" 

# CREATING KIND CLUSTERS
kind create cluster --config ./kind/application-cluster.yaml
kind create cluster --config ./kind/argocd-cluster.yaml

# DEPLOYING ARGOCD
kubectl create ns argocd
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-cd/master/manifests/install.yaml -n argocd
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "NodePort"}}'

echo "Start waiting for pod to be ready $(date)"
kubectl wait po  -l app.kubernetes.io/name=argocd-server --for=condition=Ready -n argocd
echo "Pod ready $(date)"

# PORT FORWARD
rm pid-argocd-server-8080.txt
rm pid-argocd-server-8083.txt

nohup kubectl port-forward svc/argocd-server -n argocd 8080:80 > pid-argocd-server-8080.log &
PID=$!
echo "$PID" > pid-argocd-server-8080.txt

nohup kubectl port-forward svc/argocd-server -n argocd 8083:443 > pid-argocd-server-8083.log &
PID=$!
echo "$PID" > pid-argocd-server-8083.txt

# GETTING ARGO PASSWORD
argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo "ArgoCD Admin pass: $argoPass"

# LOGIN in ARGO CLI
argocd login --insecure --grpc-web 127.0.0.1:8083 --username admin --password $argoPass

# REGISTERING a new cluster into ARGO using CLI
argocd cluster add kind-application-cluster -y

# CREATING A NEW ARGO PROJECT DECLARATIVELY
kubectl apply -f example-10.appproject.yaml  

# DEPLOYING ARGO APP
kubectl apply -f example-10.application.yaml 

open -a firefox -g https://localhost:8083/settings/clusters

echo "Installation finished!"