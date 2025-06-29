# ============================================================
# Argocd Server install & argocd-server type change
# ============================================================
$ kubectl create namespace argocd
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
$ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# ============================================================
# Argocd Server helm install
# ============================================================
$ helm repo add argo https://argoproj.github.io/argo-helm
$ helm repo update
$ helm upgrade -i argocd -n argocd argo/argo-cd --set crds.keep=false
$ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# ============================================================
# Argocd CLI Install
# ============================================================
$ ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
$ curl -sSL -o /tmp/argocd-${ARGOCD_VERSION} https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64
$ chmod +x /tmp/argocd-${ARGOCD_VERSION}
$ sudo mv /tmp/argocd-${ARGOCD_VERSION} /usr/local/bin/argocd 
$ argocd version --client

# ============================================================
# Argocd Login & password Change
# ============================================================
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
$ kubectl create clusterrolebinding default-admin --clusterrole=admin --serviceaccount=prd-cicd:default
$ sudo argocd login ARGOCD_SERVER
$ sudo argocd account update-password