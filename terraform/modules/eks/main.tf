terraform {
  required_version = ">= 1.9.0, < 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
  }
}

variable "cluster_name" { type = string }
variable "kubernetes_version" { type = string }
variable "vpc_id" { type = string }
variable "private_subnets" { type = list(string) }
variable "project" { type = string }
variable "env" { type = string }
variable "owner" { type = string }
variable "cost_center" { type = string }
variable "node_instance_types" { type = list(string) }
variable "node_min_size" { type = number }
variable "node_desired_size" { type = number }
variable "node_max_size" { type = number }
variable "enable_spot" { type = bool }

locals {
  tags = {
    Project    = var.project
    Env        = var.env
    Owner      = var.owner
    CostCenter = var.cost_center
    ManagedBy  = "terraform"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.2"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_public_access = true

  enable_irsa = true

  cluster_encryption_config = {
    resources = ["secrets"]
  }

  create_kms_key = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  access_entries = {
    platform_admin = {
      principal_arn = "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<EKS_ADMIN_ROLE>"
      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  eks_managed_node_groups = {
    on_demand = {
      name           = "${var.env}-on-demand"
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      desired_size   = var.node_desired_size
      max_size       = var.node_max_size

      capacity_type = "ON_DEMAND"

      labels = {
        workload = "general"
      }

      tags = local.tags
    }

    spot = var.enable_spot ? {
      name           = "${var.env}-spot"
      instance_types = var.node_instance_types
      min_size       = 0
      desired_size   = 0
      max_size       = var.node_max_size

      capacity_type = "SPOT"

      labels = {
        workload = "spot"
      }

      taints = {
        spot = {
          key    = "capacity-type"
          value  = "spot"
          effect = "NO_SCHEDULE"
        }
      }

      tags = local.tags
    } : null
  }

  tags = local.tags
}
