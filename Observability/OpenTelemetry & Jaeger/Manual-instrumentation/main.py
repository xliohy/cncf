from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

import os
import uvicorn
from fastapi import FastAPI

# OTLP 엔드포인트 설정정
otel_endpoint = os.environ.get('OTEL_EXPORTER_OTLP_ENDPOINT') or 'otel-collector-trace-collector.otel.svc.cluster.local:4317'

app = FastAPI()

# OpenTelemetry 리소스 설정 (서비스 이름, 버전, 호스트 등 제공) -> process
resource = Resource.create({
    "service.name": os.environ.get('OTEL_SERVICE_NAME') or 'fastapi',  # 서비스 이름 설정
    "service.version": os.environ.get('OTEL_SERVICE_VERSION') or '1.0.0',  # 서비스 버전 설정
    "host.name": os.environ.get('HOSTNAME') or 'fastapi'  # 호스트 이름 설정 (기본값 'fastapi')
    })

# OpenTelemetry SDK 설정, 리소스를 설정하여 TracerProvider 생성
trace.set_tracer_provider(TracerProvider(resource=resource))

# OTLP Span Exporter 설정 (지정된 엔드포인트로 trace 데이터를 전송)
otlp_exporter = OTLPSpanExporter(endpoint=otel_endpoint, insecure=True)

# BatchSpanProcessor를 추가하여 Span을 비동기적으로 배치 처리 후 전송
span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

# FastAPI 앱을 자동으로 계측하여 요청에 대한 Span을 생성하도록 설정
FastAPIInstrumentor.instrument_app(app)

@app.get("/")
def health_check():
    """
    헬스 체크 엔드포인트로 현재 Span에 커스텀 태그를 추가
    """
    current_span = trace.get_current_span()  # 현재 Span을 가져옴
    if current_span:
        current_span.set_attribute("project.name", "otel")  # Span에 커스텀 태그 추가
    return {"message": "Hello World"}

def main():
    uvicorn.run(app, host="0.0.0.0", port=8080) 

if __name__ == "__main__":
    main()
