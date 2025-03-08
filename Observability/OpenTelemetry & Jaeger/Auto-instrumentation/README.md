# annotations golang
```sh
sidecar.istio.io/rewriteAppHTTPProbers: "true"
instrumentation.opentelemetry.io/inject-go: "trace-instrumentation"
instrumentation.opentelemetry.io/otel-go-auto-target-exe: "/src/GolangFileName" # 알아서 타겟팅 및 분석할 golang 파일을 지정하면 됨.
```
# opentelemetry operator system deployment edit -> args: --enable-go-instrumentation=true 

# golang에서는 Sidecar 배포를 해줌. -> 다른 언어는 Sidecar 배포를 안하고, otel init container 배포해함.

# OTEL 에서 auto-instrumentation을 지원하는 언어
```sh
.NET: instrumentation.opentelemetry.io/inject-dotnet: "true"
Deno: instrumentation.opentelemetry.io/inject-sdk: "true"
Go: instrumentation.opentelemetry.io/inject-go: "true"
Java: instrumentation.opentelemetry.io/inject-java: "true"
Node.js: instrumentation.opentelemetry.io/inject-nodejs: "true"
Python: instrumentation.opentelemetry.io/inject-python: "true"
```