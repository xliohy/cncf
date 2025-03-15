# Amazon S3 Helm Chart 

helm chart를 `Github Repository`가 아닌 `Amazon S3`에서도 사용할 수 있습니다. 이번엔 Amazon S3에서 Helm Chart를 구성해보겠습니다 :   
우선 EC2 Instnace에 접근을 하여 Amazon S3에 있는 파일들을 전부 다 EC2에 올려야 합니다 :   
  1. 참고 사이트 : `https://docs.aws.amazon.com/ko_kr/prescriptive-guidance/latest/patterns/set-up-a-helm-v3-chart-repository-in-amazon-s3.html` 

### Preparations :
    - S3    -> `aws s3 mb s3://dev-s3-helm-nginx`  
    - VPC  
    - EC2  

우선 helm를 설치하여, Helm Create을 생성을 해야 합니다 : 

```sh 
$ sudo curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
$ helm version --short
$ helm create s3-helm-chart
```

그리고 s3-helm-chart로 이동한 후에, templates에 있는 파일들을 전부 다 옮긴 후에, s3 Object에 Upload까지 수행 합니다 : 

```sh
$ $m -f s3-helm-chart/templates/*
$ rm -f s3-helm-chart/values.yaml
$ mv deployment.yaml service.yaml ingress.yaml s3-helm-chart/templates/
$ mv values.yaml s3-helm-chart
$ aws s3 sync s3-helm-chart/ s3://dev-s3-helm-nginx/s3-helm-chart/
```

Amazon S3 helm-chart를 이용하기 위해서는 `helm-s3`를 설치해야 합니다 :

```sh
$ helm plugin install https://github.com/hypnoglow/helm-s3.git
$ helm s3 
```

이 명령은 대상에 index.yaml 파일을 생성하여 해당 위치에 저장된 모든 차트 정보를 추적합니다 : 
index.yaml 파일이 생성되었는지 확인하려면 `aws s3 ls s3://dev-s3-helm-nginx/s3-helm-chart/` 명령을 실행합니다.

```sh
$ helm s3 init s3://dev-s3-helm-nginx/s3-helm-chart
```

Amazon S3 리포지토리를 클라이언트 시스템의 Helm에 추가합니다 :

```sh
$ helm repo add nginx s3://dev-s3-helm-nginx/s3-helm-chart/
```

생성 또는 복제한 차트를 패키징하려면 `helm package ./s3-helm-chart` 명령을 사용합니다 :

```sh
$ helm package ./s3-helm-chart
```

Amazon S3에서 Helm 리포지토리에 로컬 패키지를 업로드하려면 `helm s3 push ./s3-helm-chart-0.1.0.tgz nginx` 명령을 실행합니다. 명령에서 `s3-helm-chart`는 차트 폴더 이름이며, `0.1.0`은 `Chart.yaml`에서 언급한 차트 버전이고, `nginx`은 대상 리포지토리 별칭입니다.

```sh
$ helm s3 push ./s3-helm-chart-0.1.0.tgz nginx
$ helm search repo nginx
```

values.yaml에서 `replicaCount` 값을 1로 설정한 다음 차트를 패키징합니다. 이번에는 버전을 `Chart.yaml`에서 `0.1.1`로 변경합니다. 버전 제어는 `CI/CD` 파이프라인에서 GitVersion 또는 Jenkins 빌드 번호와 같은 도구를 사용하여 자동화하는 것이 이상적입니다. 버전 번호 자동화는 이 패턴의 범위를 벗어납니다. 이 패키지를 설치하려면 `helm package ./s3-helm-chart` 명령을 실행합니다.  

`새로운 패키지인 버전 0.1.1을 Amazon S3의 my-helm-charts Helm 리포지토리로 푸시하려면 helm s3 push ./s3-helm-chart-0.1.1.tgz nginx 명령을 실행합니다.`

업데이트된 차트가 로컬과 Amazon S3 Helm 리포지토리에 모두 나타나는지 확인하려면 다음 명령을 실행합니다.

```sh
$ helm repo update 
$ helm search repo nginx
NAME                    CHART VERSION   APP VERSION     DESCRIPTION                
nginx/s3-helm-chart     0.1.0                           A Helm chart for Kubernetes
```

 Amazon S3 Helm 리포지토리에서 새 버전(0.1.1)을 설치하려면 `helm upgrade --install nginx nginx/s3-helm-chart --version 0.1.1 --namespace dev` 명령을 사용하세요.

 ```sh
 $ helm upgrade --install nginx nginx/s3-helm-chart --version 0.1.1 --namespace dev
 $ k get pods -n dev
 ```

 자동 롤백은 이 패턴의 범위를 벗어납니다. 이전 수정 버전으로 수동 롤백하려면 `helm rollback nginx 1` 명령을 사용하세요. 