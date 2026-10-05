variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "gitops-eks-platform"
}

variable "owner" {
  type    = string
  default = "<OWNER>"
}

variable "cost_center" {
  type    = string
  default = "<COST_CENTER>"
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name."
}

variable "lock_table_name" {
  type    = string
  default = "gitops-eks-platform-terraform-lock"
}

variable "github_repository" {
  type        = string
  description = "GitHub repository in org/repo form."
  default     = "<GITHUB_ORG>/<GITHUB_REPO>"
}

variable "github_oidc_thumbprint" {
  type        = string
  description = "GitHub Actions OIDC provider thumbprint."
  default     = "<GITHUB_OIDC_THUMBPRINT>"
}
