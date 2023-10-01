variable "cluster_name" {
  description = "The name for the GKE cluster"
  type        = string
}
variable "cluster_location" {
  description = "Cluster location"
  type        = string
}
variable "project_id" {
  type        = string
  sensitive   = true
  description = "The project name of your project"
}
variable "region" {
  description = "The region to host the cluster in"
  type        = string
}
variable "gh_repo_secret" {
  description = "The json object with fields needed to confiure argocd github repo using gh app"
  type        = any
}
variable "argocd_chart_version" {
  description = "Argocd chart version to be deployed"
  type        = string
}