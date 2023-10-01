variable "cluster_name" {
  description = "The name for the GKE cluster"
  type        = string
}
variable "location" {
  description = "The node locations for the GKE node pool"
  type        = string
}
variable "project_id" {
  type        = string
  sensitive   = true
  description = "The project ID of your project"
}
variable "region" {
  description = "The region to host the cluster in"
  type        = string
}