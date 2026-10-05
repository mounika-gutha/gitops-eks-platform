# Observability

## Metrics

Prometheus scrapes Kubernetes infrastructure and the FastAPI ServiceMonitor.

The application exposes:

- request count
- request latency
- HTTP status
- health/readiness endpoints

## Logs

Alloy runs as a DaemonSet and forwards Kubernetes pod logs to Loki.

Grafana is configured with both Prometheus and Loki datasources.

## Dashboards

The repository includes:

- Cluster Health
- Application RED Metrics
- Argo CD Status
- Logs Explorer

## Retention

Dev and production retention should be adjusted based on storage and cost requirements.
The scaffold uses short operational retention rather than indefinite historical storage.
