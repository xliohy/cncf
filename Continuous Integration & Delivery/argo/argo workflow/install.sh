# ============================================================
# Argo workflow install & argo-server type change
# ============================================================
$ kubectl create namespace argo
$ kubectl apply -n argo -f "https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml"
$ kubectl patch svc argo-server -n argo -p '{"spec": {"type": "LoadBalancer"}}' # 접근 시에 HTTPS로 접근 해야합니다.

# ============================================================
# Argo CLI install
# ============================================================
# Detect OS
ARGO_OS="amd64"
if [[ uname -s != "Darwin" ]]; then
  ARGO_OS="linux"
fi

# Download the binary
curl -sLO "https://github.com/argoproj/argo-workflows/releases/download/v3.6.4/argo-$ARGO_OS-amd64.gz"

# Unzip
gunzip "argo-$ARGO_OS-amd64.gz"

# Make binary executable
chmod +x "argo-$ARGO_OS-amd64"

# Move binary to path
sudo mv "./argo-$ARGO_OS-amd64" /usr/local/bin/argo

# Test installation
argo version

# ============================================================
# Argo workflow manifest apply 
# ============================================================

$ argo submit -n argo hello-world-3.yaml