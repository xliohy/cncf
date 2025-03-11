# fluxCD

flux는 쿠버네티스를 위한 GitOps 도구 입니다. flux는 git에 있는 쿠버네티스를 manifest를 읽고, 쿠버네티스에 manifest를 배포를 합니다. 

### fluxCD vs ArgoCD 
fluxCD는 ARgoCD와 같은 역할을 하고 있어 비교 대상으로 자주 언급이 됩니다. 둘 다 GitOps 도구니깐요 flux는 argocd에 비해 `kustomize`에 매우 특화된 도구라고 생각이 듭니다. argocd는 `kustomize`를 사용할 때 Default 설정이 부족하기 때문에, Argocd configmap 에서 kustomize 옵션을 하나하나 설정을 해야 합니다. 반면에 flux는 바로 kustomize를 사용하도록 설정이 된 것 같습니다. 이제 fluxCD와 ArgoCD에 큰 차이점은 fluxCD는 `Terraform`로 실행이 가능하다는 것입니다.

`kustomize를 제외하고는 argocd가 flux에 비해 많은 기능을 지원합니다. flux는 멀티 클러스터 배포가 어렵고 권한관리, SSO연동을 지원하지 않습니다.`

### fluxCD Concept
flux는 쿠버네티스 operator 패턴을 사용합니다. 사용자가 쿠버네티스에 배포할 내용을 flux CRD로 정의하면, flux controller가 CRD를 읽어 리소스를 쿠버네티스에 배포합니다. 핵심 CRD는 소스(Source)와 애플리케이션(Application)입니다. 소스는 Git , helm repository 등 manifest 주소를 설정 합니다. 애플리케이션은 `helm` 또는 `kustomize`를 사용하여, manifest에 배포합니다.
