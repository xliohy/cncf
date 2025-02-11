# Dapr install 

### Preparations
    - Amazon EBS CSI Driver 
    - kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
  
Kuberenetes install : 

Allow the EKS cluster to communicate with the Dapr sidecar by creating an inbound rule for port 4000.

```sh
$ aws ec2 authorize-security-group-ingress --region ap-northeast-2 \
--group-id sg-0123456789abcdef0 \
--protocol tcp \
--port 4000 \
--source-group sg-0123456789abcdef0
```

git clone dapr :

```sh 
$ git clone https://github.com/dapr/quickstarts.git
$ cd quickstarts/tutorials/hello-kubernetes
```

start dapr :

```sh
$ dapr init -k --dev