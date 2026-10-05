terraform {
  required_version = ">= 1.9.0, < 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project    = var.project
      Env        = var.env
      Owner      = var.owner
      CostCenter = var.cost_center
      ManagedBy  = "terraform"
    }
  }
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

module "vpc" {
  source = "../../modules/vpc"

  name              = "${var.project}-${var.env}"
  region            = var.aws_region
  project           = var.project
  env               = var.env
  owner             = var.owner
  cost_center       = var.cost_center
  vpc_cidr          = var.vpc_cidr
  availability_zones = var.availability_zones
}

module "eks" {
  source = "../../modules/eks"

  cluster_name        = "${var.project}-${var.env}"
  kubernetes_version  = var.kubernetes_version
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnets
  project             = var.project
  env                 = var.env
  owner               = var.owner
  cost_center         = var.cost_center
  node_instance_types = var.node_instance_types
  node_min_size       = var.node_min_size
  node_desired_size   = var.node_desired_size
  node_max_size       = var.node_max_size
  enable_spot         = true
}

module "iam" {
  source = "../../modules/iam"

  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url   = module.eks.cluster_oidc_issuer_url
  project           = var.project
  env               = var.env
  owner             = var.owner
  cost_center       = var.cost_center
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name = "${var.project}/sample-api"
  project        = var.project
  env            = var.env
  owner          = var.owner
  cost_center    = var.cost_center
}

module "budgets" {
  source = "../../modules/budgets"

  name         = "${var.project}-${var.env}-monthly"
  limit_usd    = 100
  alert_email  = var.budget_alert_email
  project      = var.project
  env          = var.env
  owner        = var.owner
  cost_center  = var.cost_center
}

module "addons" {
  source = "../../modules/addons"

  argocd_namespace     = "argocd"
  argocd_chart_version = "7.8.23"
  gitops_repo_url      = var.gitops_repo_url
  gitops_revision      = var.gitops_revision
}
