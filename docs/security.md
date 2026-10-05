# Security

## Identity

GitHub Actions uses GitHub's OIDC identity token to assume an AWS IAM role.
Long-lived AWS access keys are intentionally not stored in GitHub secrets.

## Infrastructure

- EKS secrets encryption uses KMS.
- Private subnets host worker nodes.
- Public subnets are used for internet-facing load balancers.
- Security groups should be reviewed before production use.

## Containers

The FastAPI image:

- uses a slim Python base image
- uses a non-root user
- drops Linux capabilities
- disallows privilege escalation
- uses a read-only root filesystem at runtime

## CI security

- Checkov
- TFLint
- Trivy
- Gitleaks
- dependency review

## Secrets

Application/platform secrets are references to AWS Secrets Manager through
External Secrets.

Never commit:

- AWS access keys
- AWS secret keys
- private keys
- API keys
- passwords
- personal phone numbers

## IAM

IRSA roles are separated by controller:

- AWS Load Balancer Controller
- Cluster Autoscaler
- External Secrets
- EBS CSI
