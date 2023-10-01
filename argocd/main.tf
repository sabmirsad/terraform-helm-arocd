resource "random_password" "argocd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

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

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_chart_version
  namespace        = "argocd"
  create_namespace = true
  set {
    name  = "configs.secret.argocdServerAdminPassword"
    value = bcrypt_hash.argo.id
  }
}

data "google_secret_manager_secret_version" "github_repo_secret" {
  secret = var.gh_repo_secret
}

locals {
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

