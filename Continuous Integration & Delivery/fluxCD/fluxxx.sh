# Install using Bash
# To install the latest release on Linux, macOS or Windows WSL:

$ curl -s https://fluxcd.io/install.sh | sudo FLUX_VERSION=2.0.0 bash
$ kubectl create ns flux-system
$ flux install --namespace=flux-system

# github토큰을 발급한 후, 아래 명령어를 입력하여 flux를 설치합니다.
# flux가 설치되면 flux-system namespace에 쿠버네티스 리소스가 생성됩니다.
$ export GITHUB_TOKEN=<your-token>
$ export GITHUB_USER=<your-username>

$ flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=fluxxx \
  --branch=main \
  --path=./clusters/<my-cluster-name> \
  --personal

# 소스는 flux애플리케이션이 참조하는 소스정보입니다. 소스유형은 git, helm, oci, bucket이 있습니다. 소스생성은 flux create source명령어를 사용합니다.
$ GITURL="https://github.com/sungwook-practice/fluxcd-test.git"
flux create source git nginx-example1 \  # git 유형 flux source 생성
--url=$GITURL \
--branch=main \
--interval=30s # 30s 마다 Sync를 함.

# 생성된 소스는 flux get 또는 kubectl crd로 조회가능합니다. kubectl crd로 조회하면 소스주소를 확인할 수 있습니다.
$ flux get sources git
$ kubectl -n flux-system get gitrepositories

# 참고자료: https://fluxcd.io/flux/faq/#can-i-use-repositories-with-plain-yamls

# 아래 예제는 이전에 생성한 nginx-example1 git source를 사용하여, flxu 애플리케이션을 생성합니다. 배포할 manifest는 nginx 디렉터리에 있는 manifest입니다.
$ flux create kustomization nginx-example1 \
  --target-namespace=default \
  --interval=1m \
  --source=nginx-example1 \
  --path="./nginx" \
  --health-check-timeout=2m

# 아래 예제는 이전에 생성한 애플리케이션을 삭제했습니다.
$ flux -n default delete kustomization nginx-example1