# Observability 
  
opentelemetry install : -> helm install 보다 operator 설치가 훨씬 편하게 설치할 수 있습니다. 

OTEL Operator 
1. helm
2. kubernetes Operator

```sh
$ kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.17.0/cert-manager.yaml
$ kubectl apply -f https://github.com/open-telemetry/opentelemetry-operator/releases/latest/download/opentelemetry-operator.yaml
```

### OTEL(OpenTelemetry) & Jaeger

OTEL이란? prometheus or mimir
- 트레이싱, 추적, 로그 데이터를 수집하기 위한 오픈소스

Observability vs Monitoring
- Observability: Monitoring보다 세세하게 관찰하는 방식(CPU, Memory, Log 모니터링 불가) -> 서버 Error 상황 때 많이 사용. 
- Monitoring: CPU, Memory, Logs를 관찰하는 방식 -> 세세한 모니터링 불가. 

1. OpenTelemetry Operator
- OpenTelemetry 컴포넌트들 예를 들면 Collector 이런 애들을 쉽게 배포해주고, 관리함

2. OpenTelemetry Collector
- 데이터를 수집
- 데이터 송/수신

3. OpenTelemetry Exporter
- Collector로 들어온 데이터를 다른 Monitoring or Observability 서비스로 전송

# OTEL에 데이터 전송하는 법
1. Auto-instrumentation
2. Manual-Instrumentation

### golang말고 다른 언어에서 resource limit, request를 설정안한 이유

`Golang` 언어를 제외한 모든 언어에서 Resource limit , request를 설정을 안한 이유.

- otel init container가 초기 설정을 함.
    -> 이때 리소스 사용량이 쫌 높아짐
    -> 리소스 제한이 걸리면, init container가 작업하다 뻣거나, Pod자체가 Hang 걸림

### golang은 왜 limit 설정을 할 수 있을까 ??? 
- Sidecar가 떠서 , 리소스 사용량을 잡아먹지 않기 때문에 가능함.