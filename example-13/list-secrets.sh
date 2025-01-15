#!/bin/bash

# kubectl version
# Client Version: v1.32.0
# Kustomize Version: v5.5.0
# Server Version: v1.29.2
# WARNING: version difference between client (1.32) and server (1.29) exceeds the supported minor version skew of +/-1

echo "-manifests-------------------------------------------------------"
date

kubectl wait --for=create namespace/manifests --timeout=600s

kubectl wait --for=create secret/data-1-secret --timeout=60s -n manifests
val=$(kubectl -n manifests get secret data-1-secret -o yaml | yq .data.passwordInline | base64 -d)
echo "data-1-secret.data.passwordInline = $val"
val=$(kubectl -n manifests get secret data-1-secret -o yaml | yq .data.usernameInline | base64 -d)
echo "data-1-secret.data.usernameInline = $val"

kubectl wait --for=create secret/string-1-secret --timeout=60s -n manifests
val=$(kubectl -n manifests get secret string-1-secret -o yaml | yq .data.passwordInline | base64 -d)
echo "string-1-secret.data.passwordInline = $val"
val=$(kubectl -n manifests get secret string-1-secret -o yaml | yq .data.usernameInline | base64 -d)
echo "string-1-secret.data.usernameInline = $val"

kubectl wait --for=create secret/string-2-secret --timeout=60s -n manifests
val=$(kubectl -n manifests get secret string-2-secret -o yaml | yq .data.password | base64 -d)
echo "string-2-secret.data.password = $val"
val=$(kubectl -n manifests get secret string-2-secret -o yaml | yq .data.username | base64 -d)
echo "string-2-secret.data.username = $val"

date
