terraform {
  required_version = ">= 1.9.0, < 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70"
    }
  }
}

variable "name" { type = string }
variable "region" { type = string }
variable "project" { type = string }
variable "env" { type = string }
variable "owner" { type = string }
variable "cost_center" { type = string }
variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }

locals {
  az_count = length(var.availability_zones)
  common_tags = {
    Project    = var.project
    Env        = var.env
    Owner      = var.owner
    CostCenter = var.cost_center
    ManagedBy  = "terraform"
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.18.1"

  name = var.name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, i)]
  public_subnets  = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 4, i + local.az_count)]

  enable_nat_gateway = true
  single_nat_gateway = var.env == "dev"

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }

  tags = local.common_tags
}
