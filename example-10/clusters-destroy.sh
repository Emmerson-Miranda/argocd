#!/bin/bash

#kill -9 $(cat pid-argocd-server-8080.txt)
#kill -9 $(cat pid-argocd-server-8083.txt)

kind delete cluster --name argocd-cluster
kind delete cluster --name application-cluster
