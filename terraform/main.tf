
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
  }
}

provider "kubernetes" {
  config_path = pathexpand("~/.kube/config")
}

data "kubernetes_namespace" "default" {
  metadata {
    name = "default"
  }
}

resource "kubernetes_namespace_v1" "terraform_lab" {
  metadata {
    name = "terraform-lab"
  }
}

output "kubernetes_namespace" {
  description = "Namespace used by the voting application"
  value       = data.kubernetes_namespace.default.metadata[0].name
}

output "terraform_lab_namespace" {
  description = "Namespace managed by Terraform"
  value       = kubernetes_namespace_v1.terraform_lab.metadata[0].name
}
