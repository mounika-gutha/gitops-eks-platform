import json
import logging
import os
import time
import uuid

from fastapi import FastAPI, Request
from prometheus_client import Counter, Histogram, generate_latest
from starlette.responses import Response

APP_VERSION = os.getenv("APP_VERSION", "0.1.0")

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP requests",
    ["method", "path", "status"],
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency",
    ["method", "path"],
)

logging.basicConfig(level=logging.INFO, format="%(message)s")
logger = logging.getLogger("sample-api")

app = FastAPI(title="sample-api", version=APP_VERSION)


@app.middleware("http")
async def metrics_and_logging(request: Request, call_next):
    started = time.perf_counter()
    request_id = request.headers.get("x-request-id", str(uuid.uuid4()))

    try:
        response = await call_next(request)
        return response
    finally:
        elapsed = time.perf_counter() - started
        path = request.url.path
        status = locals().get("response").status_code if "response" in locals() else 500

        REQUEST_COUNT.labels(request.method, path, status).inc()
        REQUEST_LATENCY.labels(request.method, path).observe(elapsed)

        logger.info(json.dumps({
            "request_id": request_id,
            "method": request.method,
            "path": path,
            "status": status,
            "duration_ms": round(elapsed * 1000, 2),
        }))


@app.get("/")
def root():
    return {"service": "sample-api", "version": APP_VERSION}


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/ready")
def ready():
    return {"status": "ready"}


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), media_type="text/plain; version=0.0.4")
