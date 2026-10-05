# Bootstrap

This directory creates the shared Terraform state backend and GitHub Actions OIDC roles.

Run this once per AWS account/environment foundation.

Do not commit `terraform.tfvars`.

The bootstrap state remains local because the bootstrap process creates the remote state resources themselves.
