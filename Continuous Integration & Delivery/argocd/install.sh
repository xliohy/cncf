# ============================================================
# Argocd Server install & argocd-server type change
# ============================================================
$ kubectl create namespace argocd
$ kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
$ kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# ============================================================
# Argocd CLI Install
# ============================================================
$ ARGOCD_VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
$ curl -sSL -o /tmp/argocd-${ARGOCD_VERSION} https://github.com/argoproj/argo-cd/releases/download/${ARGOCD_VERSION}/argocd-linux-amd64
$ chmod +x /tmp/argocd-${VERSION}
$ sudo mv /tmp/argocd-${VERSION} /usr/local/bin/argocd 
$ argocd version --client

# ============================================================
# Argocd Login & password Change
# ============================================================
$ kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
$ sudo argocd login ARGOCD_SERVER
$ argocd account update-password