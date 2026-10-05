output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "lb_controller_role_arn" {
  value = module.iam.lb_controller_role_arn
}

output "cluster_autoscaler_role_arn" {
  value = module.iam.cluster_autoscaler_role_arn
}

output "external_secrets_role_arn" {
  value = module.iam.external_secrets_role_arn
}

output "ebs_csi_role_arn" {
  value = module.iam.ebs_csi_role_arn
}
