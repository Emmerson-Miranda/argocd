echo "-manifests-------------------------------------------------------"
val=$(kubectl -n manifests get secret data-1-secret -o yaml | yq .data.passwordInline | base64 -d)
echo "data-1-secret.data.passwordInline = $val"
val=$(kubectl -n manifests get secret data-1-secret -o yaml | yq .data.usernameInline | base64 -d)
echo "data-1-secret.data.usernameInline = $val"

val=$(kubectl -n manifests get secret string-1-secret -o yaml | yq .data.passwordInline | base64 -d)
echo "string-1-secret.data.passwordInline = $val"
val=$(kubectl -n manifests get secret string-1-secret -o yaml | yq .data.usernameInline | base64 -d)
echo "string-1-secret.data.usernameInline = $val"

val=$(kubectl -n manifests get secret string-2-secret -o yaml | yq .data.password | base64 -d)
echo "string-2-secret.data.password = $val"
val=$(kubectl -n manifests get secret string-2-secret -o yaml | yq .data.username | base64 -d)
echo "string-2-secret.data.username = $val"
