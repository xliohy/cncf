1. Rollout 경우에는 `rollout-bluegreen-active` , `rollout-bluegreen-preview`가 서비스가 생성이 되어 있지 않은 경우에 Pods가 생성이 되지 않습니다. 
2. keep alive 설정으로 인해서, Service에서 `describe` 확인 시에 전환이 잘 되어도 ALB에서 확인할 때 전환이 느리게 됩니다. 이 경우는 keep alive 때문에 ingress controller를 사용해야 합니다.
  
    -> Nginx Ingress Controller  
    -> Istio Ingress Controller  
    -> Kong Ingress Controller  
    -> Envoy Ingress Controller  