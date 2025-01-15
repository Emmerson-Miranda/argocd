echo "-helm chart-------------------------------------------------------"

kubectl wait --for=create namespace/helmchart --timeout=600s

kubectl wait --for=create secret/vault-example --timeout=60s -n manifests

val=$(kubectl -n helmchart get secret vault-example -o yaml | yq .data.passwordInline | base64 -d)
echo "vault-example.data.passwordInline = $val"
val=$(kubectl -n helmchart get secret vault-example -o yaml | yq .data.passwordValues | base64 -d)
echo "vault-example.data.passwordValues = $val"
