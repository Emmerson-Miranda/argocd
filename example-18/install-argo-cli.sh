
argo version
if [ $? -eq 0 ]; then
       echo 'argo CLI already installed!'
else
    echo 'Installing argo CLI!'

    ARGO_OS="darwin"

    # Download the binary
    curl -sLO "https://github.com/argoproj/argo-workflows/releases/download/v3.6.0/argo-$ARGO_OS-amd64.gz"

    # Unzip
    gunzip "argo-$ARGO_OS-amd64.gz"

    # Make binary executable
    chmod +x "argo-$ARGO_OS-amd64"

    # Move binary to path
    mv "./argo-$ARGO_OS-amd64" /usr/local/bin/argo

    # Test installation
    argo version
fi

