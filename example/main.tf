module "argocd" {
  source               = "github.com/sabmirsad/terraform-helm-arocd//argocd"
  cluster_name         = var.cluster_name
  location             = var.cluster_location
  project_id           = var.project_id
  region               = var.region
  gh_repo_secret       = var.gh-repo-secret
  argocd_chart_version = "5.46.7"

  # This resource could be used in the same terraform apply with
  # cluster creation: just uncomment the line under and set the dependency resource 
  #   depends_on = [ google_container_cluster.my_cluster ]
}