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
variable "oidc_provider_arn" { type = string }
variable "oidc_issuer_url" { type = string }
variable "project" { type = string }
variable "env" { type = string }
variable "owner" { type = string }
variable "cost_center" { type = string }

locals {
  oidc_host = replace(var.oidc_issuer_url, "https://", "")
  tags = {
    Project    = var.project
    Env        = var.env
    Owner      = var.owner
    CostCenter = var.cost_center
    ManagedBy  = "terraform"
  }
}

data "aws_iam_policy_document" "irsa_trust" {
  for_each = toset([
    "aws-load-balancer-controller",
    "cluster-autoscaler",
    "external-secrets",
    "ebs-csi-controller"
  ])

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.oidc_provider_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_host}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "${local.oidc_host}:sub"
      values   = ["system:serviceaccount:*:${each.key}"]
    }
  }
}

resource "aws_iam_role" "lb_controller" {
  name               = "${var.project}-${var.env}-lb-controller"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust["aws-load-balancer-controller"].json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "lb_controller" {
  role       = aws_iam_role.lb_controller.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSLoadBalancingPolicy"
}

resource "aws_iam_role" "cluster_autoscaler" {
  name               = "${var.project}-${var.env}-cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust["cluster-autoscaler"].json
  tags               = local.tags
}

resource "aws_iam_role_policy" "cluster_autoscaler" {
  role = aws_iam_role.cluster_autoscaler.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "external_secrets" {
  name               = "${var.project}-${var.env}-external-secrets"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust["external-secrets"].json
  tags               = local.tags
}

resource "aws_iam_role_policy" "external_secrets" {
  role = aws_iam_role.external_secrets.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.name}:<AWS_ACCOUNT_ID>:secret:${var.project}/*"
      }
    ]
  })
}

data "aws_region" "current" {}

resource "aws_iam_role" "ebs_csi" {
  name               = "${var.project}-${var.env}-ebs-csi"
  assume_role_policy = data.aws_iam_policy_document.irsa_trust["ebs-csi-controller"].json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role       = aws_iam_role.ebs_csi.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}
