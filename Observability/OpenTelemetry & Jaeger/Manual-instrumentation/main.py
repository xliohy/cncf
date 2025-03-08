from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import SERVICE_NAME, Resource
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor

import os
import uvicorn
from fastapi import FastAPI

otel_endpoint=os.environ.get('OTEL_EXPORTER_OTLP_ENDPOINT') or 'otel-collector-trace-collector.otel.svc.cluster.local:4317'

app = FastAPI()

# Setting Resource
resource = Resource.create({
    "service.name": os.environ.get('OTEL_SERVICE_NAME') or 'fastapi',
    "service.version": os.environ.get('OTEL_SERVICE_VERSION') or '1.0.0',
    "host.name": os.environ.get('HOSTNAME') or 'fastapi'
    })

# setting sdk
trace.set_tracer_provider(TracerProvider(resource=resource))

# setup OLTP exporter 
otlp_exporter = OTLPSpanExporter(endpoint=otel_endpoint, insecure=True)
span_processor = BatchSpanProcessor(otlp_exporter)
trace.get_tracer_provider().add_span_processor(span_processor)

# instrumentation
FastAPIInstrumentor.instrument_app(app)

@app.get("/")
def health_check():
    """
    current_span custom tags
    """
    current_span = trace.get_current_span()
    if current_span:
        current_span.set_attribute("project.name", "otel") # custom Tags
    return {"message": "Hello World"}

def main():
    uvicorn.run(app, host="0.0.0.0", port=8080)

if __name__ == "__main__":
    main()