variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "gitops-eks-platform"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "owner" {
  type    = string
  default = "<OWNER>"
}

variable "cost_center" {
  type    = string
  default = "<COST_CENTER>"
}

variable "kubernetes_version" {
  type    = string
  default = "1.31"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "gitops_repo_url" {
  type    = string
  default = "<GITOPS_REPO_URL>"
}

variable "gitops_revision" {
  type    = string
  default = "main"
}

variable "budget_alert_email" {
  type    = string
  default = "<BUDGET_ALERT_EMAIL>"
}
