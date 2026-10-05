terraform {
  backend "s3" {
    bucket         = "<TF_STATE_BUCKET>"
    key            = "gitops-eks-platform/dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "gitops-eks-platform-terraform-lock"
    encrypt        = true
  }
}
