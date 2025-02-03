# test-project

1. `mkdir /account/ ;  echo 'root:password' > /account/credentials` cat /account/credentials 명령어 수행 시, access denied가 띄도록 구성합니다.  

```sh 
apiVersion: security.kubearmor.com/v1
kind: KubeArmorPolicy
metadata:
  name: ksp-ubuntu-3-file-dir-allow-from-source-path
  namespace: green
spec:
  severity: 10
  message: "a critical directory was accessed"
  tags:
  - WARNING
  selector:
    matchLabels:
      app: green
  file:
    matchDirectories:
    - dir: /account/
      fromSource:
      - path: /bin/cat
  action:
    Block
```

2. `cp /bin/* /usr/bin` 명령어를 수행 후에, /usr/bin에서 실행되는 모든 파일들을 허용하지만, kubearmor에 logs는 찍힐 수 있도록 합니다.   

```sh
apiVersion: security.kubearmor.com/v1
kind: KubeArmorPolicy
metadata:
  name: ksp-ubuntu-2-proc-dir-recursive-block
  namespace: green
spec:
  selector:
    matchLabels:
      app: green
  process:
    matchDirectories:
    - dir: /usr/bin/
      recursive: true
  action:
    Audit
```