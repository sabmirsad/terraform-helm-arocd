terraform {
  required_providers {
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

