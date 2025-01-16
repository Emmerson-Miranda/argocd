echo "-helm chart-------------------------------------------------------"

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


kubectl wait --for=create namespace/helmchart --timeout=600s

kubectl wait --for=create secret/vault-example --timeout=60s -n manifests
val=$(kubectl -n helmchart get secret vault-example -o yaml | yq .data.passwordInline | base64 -d)
echo "vault-example.data.passwordInline = $val"
val=$(kubectl -n helmchart get secret vault-example -o yaml | yq .data.passwordValues | base64 -d)
echo "vault-example.data.passwordValues = $val"

date