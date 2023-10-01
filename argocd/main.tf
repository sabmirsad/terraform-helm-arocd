data "google_client_config" "this_config" {
}

data "google_container_cluster" "this_cluster" {
  name     = var.cluster_name
  location = var.location
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.this_cluster.endpoint}"
  token = data.google_client_config.this_config.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.this_cluster.master_auth[0].cluster_ca_certificate,
  )
}

resource "random_password" "argocd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Argo requires the password to be bcrypt, we use custom provider of bcrypt,
# as the default bcrypt function generates diff for each terraform plan
resource "bcrypt_hash" "argo" {
  cleartext = random_password.argocd.result
}
resource "google_secret_manager_secret" "argocd_secret" {
  secret_id = "argocd-password-secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "argocd_secret_version" {
  secret      = google_secret_manager_secret.argocd_secret.name
  secret_data = random_password.argocd.result
}

#
# Helm provider
# Sets up access to deployed EKS in order to setup ArgoCD and enable usage of helm chart resources
#
provider "helm" {
  kubernetes {
    host = "https://${data.google_container_cluster.this_cluster.endpoint}"
    cluster_ca_certificate = base64decode(
      data.google_container_cluster.this_cluster.master_auth[0].cluster_ca_certificate,
    )
    token = data.google_client_config.this_config.access_token
  }
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "5.42.0" # Use the version you want
  namespace        = "argocd" # Namespace where ArgoCD should be deployed
  create_namespace = true
  # values     = [file("argocd-values.yaml")]
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt_hash.argo.id
  }
  # Other ArgoCD values he

}

// Retrieve the secret from Google Secret Manager
data "google_secret_manager_secret_version" "github_repo_secret" {
  secret         = var.gh_repo_secret
}

locals {
  // Parse the JSON object
  github_repo_secret = jsondecode(data.google_secret_manager_secret_version.github_repo_secret.secret_data)
}

resource "kubernetes_secret" "github_creds" {
  metadata {
    name      = "github-creds"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  data = {
    url                     = tostring(local.github_repo_secret.url)
    type                    = tostring(local.github_repo_secret.type)
    project                 = tostring(local.github_repo_secret.project)
    githubAppID             = tostring(local.github_repo_secret.githubAppID)
    githubAppInstallationID = tostring(local.github_repo_secret.githubAppInstallationID)
    githubAppPrivateKey     = local.github_repo_secret.githubAppPrivateKey
  }

  depends_on = [data.google_secret_manager_secret_version.github_repo_secret, helm_release.argocd]
}

