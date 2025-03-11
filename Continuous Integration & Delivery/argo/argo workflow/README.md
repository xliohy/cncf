# Argo workflow
Argo workflow는 Argo Project에서 만든 컨테이너 기반 워크플로우 엔진입니다. Airlfow와 비슷하게 원하는 Job을 실행할 수 있으고 각 Job간의 종속성을 부여하여 순서대로 실행할 수 있으며 병렬로 여러 Job을 동시에 실행할 수 있습니다. 차이점은 Job의 단위가 프로세스가 아닌 컨테이너 단위입니다. 또한 Airflow에서는 DAG의 표현을 파이썬 스크립트를 통해서 표현했다면 Argo workflow에서는 쿠버네티스 선언형 명령 스타일로 CustomResourceDefinition을 정의하고 YAML 파일을 만들어 쿠버네티스에 호출합니다. `Argo Workflows는 여러 개의 Job을 조합하여 복잡한 작업 흐름을 정의하고, 순서나 조건에 맞게 실행할 수 있는 반면, Kubernetes Job은 단순히 독립적인 작업을 처리하는 데 사용된다는 점에서 큰 차이가 있습니다.`

### 동작 방법
    1. 사용자가 YAML DAG 명세를 작성하여 쿠버네티스 마스터에 요청을 합니다.
    2. 쿠버네티스 API 서버가 명세를 받아 etcd DB에 workflow 정보를 저장합니다.
    3. Argo controller가 reconcilation loop에서 etcd DB의 새로운 정보를 확인하고 kube-scheduler에 필요한 Pod를 요청합니다.
    4. kube-scheduler는 Pod를 적절한 노드에 스케줄링합니다.
    5. Argo controller가 다음번 reconcilation loop에서 다음 dependency가 걸려 있는 Job을 요청합니다.

### 구성 요소

### 1. Workflows
작업 순서 설정: 여러 개의 작업(작업 단위)을 정의하고, 그 작업들이 실행되는 순서를 설정합니다.
Jenkins Pipeline과 유사: Jenkins Pipeline처럼 여러 단계를 정의하여 자동화된 파이프라인을 실행할 수 있습니다.
### 2. Argo Workflows
Kubernetes 환경에서 실행: Argo Workflows는 Kubernetes의 리소스인 Pod를 사용하여 각 단계를 실행합니다. Kubernetes와 완벽하게 통합되어, 클러스터 내에서 작업을 자동화하고 관리할 수 있습니다.
### 3. Step & DAG (Directed Acyclic Graph)
스텝 기반: 작업이 순차적으로 실행됩니다. 한 작업이 끝난 후에 다음 작업이 실행됩니다.
DAG 기반: 작업 간 의존성을 정의하여 병렬 실행이 가능합니다. DAG는 A -> B -> C와 같이 순차적으로 실행되기도 하지만, A와 B가 병렬로 실행되고 그 후 C가 실행되는 형태를 만들 수 있습니다.
### 4. Template
작업 단위 정의: 각 작업을 하나의 템플릿으로 정의합니다. 템플릿은 재사용 가능하며, 컨테이너로 실행됩니다. 예를 들어, 동일한 작업을 여러 번 실행할 필요가 있을 때, 템플릿을 사용하여 효율적으로 재사용할 수 있습니다.
### 5. Artifact & Parameter
Artifact: 실행 중에 생성된 데이터(파일 등)를 저장하고, 다른 작업에서 이 데이터를 사용할 수 있습니다. 예를 들어, 첫 번째 태스크에서 생성된 파일을 두 번째 태스크에서 사용할 수 있게 전달합니다.
Parameter: 작업 간에 변수를 전달할 수 있습니다. 예를 들어, 첫 번째 작업에서 생성된 값을 두 번째 작업의 입력 값으로 전달할 수 있습니다.
### 6. CronWorkflow
정기적 실행: 일정한 주기로 워크플로우를 자동으로 실행할 수 있습니다. 예를 들어, "매일 새벽 3시에 백업 작업을 실행"하는 방식으로 사용됩니다.