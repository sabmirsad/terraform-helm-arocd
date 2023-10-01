# # https://registry.terraform.io/providers/hashicorp/google/latest/docs
# provider "google" {
#   project = var.project_id
#   region  = var.region
# }

# # https://www.terraform.io/language/settings/backends/gcs
terraform {
  required_providers {
    # google = {
    #   source  = "hashicorp/google"
    #   version = "~> 4.0"
    # }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.17"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.8"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    bcrypt = {
      source  = "viktorradnai/bcrypt"
      version = ">= 0.1.2"
    }
  }
}

