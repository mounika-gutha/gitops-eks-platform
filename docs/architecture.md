# Architecture

```mermaid
flowchart LR
    Internet --> ALB
    ALB --> EKS

    subgraph EKS
      API[FastAPI]
      Prom[Prometheus]
      Graf[Grafana]
      Loki[Loki]
      Alloy[Alloy]
      Argo[Argo CD]
    end

    Alloy --> Loki
    Prom --> Graf
    Loki --> Graf
    Prom --> Alertmanager
    Alertmanager --> Opsgenie[Opsgenie]
