# Cost optimization

## Main cost drivers

- EKS control plane
- EC2 worker nodes
- NAT gateways
- EBS volumes
- Application Load Balancers
- CloudWatch/AWS logs
- Public IPv4 addresses

## Dev strategy

The dev environment uses smaller nodes and can use Spot capacity.

The VPC uses a single NAT gateway in dev to reduce fixed network cost.

## Production strategy

Production uses multiple on-demand nodes across three AZs for stronger availability.

## Operational controls

- AWS Budget
- ECR lifecycle policy
- Prometheus/Loki retention
- HPA
- Cluster Autoscaler
- resource requests/limits
- periodic review of idle resources

Always destroy temporary environments after demonstrations.
