# ============================================================
# Argo Rollouts helm install 
# ============================================================
$ kubectl create ns argo-rollouts
$ helm repo add argo https://argoproj.github.io/argo-helm
$ helm install argo-rollouts argo/argo-rollouts -n argo-rollouts --set dashboard.enabled=true --set dashboard.image.tag=v1.7.2 
    # 만약 재 생성을 해야하는 경우에는 argoproj crds를 삭제 후에 다시 helm install을 해야합니다. 아래 명령어 참고.
    # k delete crd  applicationsets.argoproj.io  applications.argoproj.io appprojects.argoproj.io

# ------------> https://quay.io/repository/argoproj/kubectl-argo-rollouts?tab=tags&tag=latest 
# bashboard Tags를 수정해야 합니다. latest 버전은 현재 접근이 불가한 상태로 v1.7.2 버전을 사용했습니다. 

# ============================================================
# Argo Rollouts Docs install with Dashboard Connect
# ============================================================
$ kubectl create namespace argo-rollouts
$ kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

# ------------> https://github.com/argoproj/argo-rollouts/releases
$ curl -LO https://github.com/argoproj/argo-rollouts/releases/latest/download/kubectl-argo-rollouts-linux-amd64
$ chmod +x ./kubectl-argo-rollouts-linux-amd64
$ sudo mv ./kubectl-argo-rollouts-linux-amd64 /usr/local/bin/kubectl-argo-rollouts

$ kubectl argo rollouts dashboard