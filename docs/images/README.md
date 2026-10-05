# Screenshot checklist

Capture these after the platform is deployed.

| Filename | What to show |
|---|---|
| `architecture.png` | AWS/EKS platform architecture |
| `aws-eks.png` | EKS cluster and node groups |
| `github-actions.png` | Successful CI/CD workflow |
| `argocd-applications.png` | Argo CD applications in Synced/Healthy state |
| `grafana-cluster.png` | Cluster/node health dashboard |
| `grafana-red.png` | FastAPI RED metrics |
| `grafana-logs.png` | Loki application logs |
| `alertmanager-opsgenie.png` | Alertmanager route and Opsgenie alert |

Before publishing screenshots:

- blur AWS account IDs
- blur private repository details if applicable
- blur email addresses where appropriate
- **blur phone numbers**
- never show API keys, passwords or tokens

The PNG files currently present in this directory are placeholders and should be
replaced by screenshots captured from the deployed platform.
