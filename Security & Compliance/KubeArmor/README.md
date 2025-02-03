# KubeArmor: Runtime Security
by gmstcl : sgh | on 3 Feb 2025 | in Amazon Elastic Kubernetes Service , CNCF KubeArmor
  
KuberArmor는 내부로부터 포드를 보호합니다. daemon set으로 실행되며 시스템 레벨에서 컨테이너의 동작을 제한합니다. KubeArmor를 사용하면 pods/container 내의 리소스에 대한 보안 정책을 정의하고 Runtime에 적용할 수 있습니다. 또한 정책 위반을 탐지하고 container ID가 포함된 감사 로그를 생성합니다. 컨테이너 외에도 KubeArmor는 호스트 자체를 보호할 수도 있습니다. 

## KubeArmor : Demo Getstarted 

우선 kubeArmor를 사용하기 위해서는 kubeArmor를 설치를 해줘야 합니다 :

```sh
curl -sfL http://get.kubearmor.io/ | sudo sh -s -- -b /usr/local/bin
karmor install
```

우선 Deployment를 작성을 해주고, `k apply -f deployment.yaml`을 수행 해줍니다 :

```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: green-app
  namespace: green
spec:
  replicas: 1
  selector:
    matchLabels:
      app: green
  template:
    metadata:
      labels:
        app: green
    spec:
      containers:
        - name: green-container
          image: busybox
          command:
            - "sh"
            - "-c"
            - "echo 'Starting /bin/sleep'; /bin/sleep 3600"
          resources:
            limits:
              memory: "64Mi"
              cpu: "250m"
```

정상적으로 설치가 되었다면 , 아래와 같이 KubeArmor의 정책을 작성을 해줍니다 :

```sh
apiVersion: security.kubearmor.com/v1
kind: KubeArmorPolicy
metadata:
  name: ksp-group-1-proc-path-block
  namespace: green
spec:
  severity: 5
  message: "block /bin/sleep"
  selector:
    matchLabels:
      app: green
  process:
    matchPaths:
    - path: /bin/sleep
  action:
    Block
```

위에 정책을 보면 matchLabels을 이용하여, 이 Labels이 match가 되는 Object에게 정책을 적용합니다. `severity:` 보안 위험 수준을 표현 합니다. `process` ,  `syscalls` , `file` , `network` 이렇게 종류가 있습니다. 참고 -> https://docs.kubearmor.io/kubearmor/documentation/security_policy_examples 여기서 적용한 process는 sleep 명령어를 수행하게 되면 프로세스로 sleep이 올라가게 됩니다. 이때 kubearmor /bin/sleep 프로세스를 감지하고 actions을 통해서 차단을 하게 됩니다.