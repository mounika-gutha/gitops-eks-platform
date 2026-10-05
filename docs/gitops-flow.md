# GitOps flow

```mermaid
sequenceDiagram
    participant D as Developer
    participant G as GitHub
    participant C as GitHub Actions
    participant E as ECR
    participant R as GitOps repo
    participant A as Argo CD
    participant K as EKS

    D->>G: Push application change
    G->>C: Start workflow
    C->>C: Test + Trivy scan
    C->>E: Push immutable SHA tag
    C->>R: Update dev image tag
    R->>A: Git change detected
    A->>K: Sync desired state
    K-->>A: Health status
