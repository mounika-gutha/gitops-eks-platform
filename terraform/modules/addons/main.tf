terraform {
  required_version = ">= 1.9.0, < 1.10.0"

  required_providers {
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

variable "argocd_namespace" { type = string }
variable "argocd_chart_version" { type = string }
variable "gitops_repo_url" { type = string }
variable "gitops_revision" { type = string }

resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = var.argocd_namespace
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version

  values = [file("${path.module}/../../../../gitops/platform/values/argocd-values.yaml")]
}

resource "kubernetes_manifest" "root_application" {
  depends_on = [helm_release.argocd]

  manifest = yamldecode(templatefile(
    "${path.module}/../../../../gitops/bootstrap/root-app.yaml",
    {
      gitops_repo_url = var.gitops_repo_url
      gitops_revision = var.gitops_revision
    }
  ))
}
