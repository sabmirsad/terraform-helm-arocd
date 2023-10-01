data "google_client_config" "this" {
}
data "google_container_cluster" "my_cluster" {
  name     = var.cluster_name
  location = var.cluster_location
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.my_cluster.endpoint}"
  token                  = data.google_client_config.this.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
}
provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.my_cluster.endpoint}"
    token                  = data.google_client_config.this.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.my_cluster.master_auth[0].cluster_ca_certificate)
  }
}