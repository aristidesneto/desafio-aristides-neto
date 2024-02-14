resource "google_container_cluster" "desafio_globo" {
  name     = var.cluster_name
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "google_container_node_pool" "desafio_globo_nodes" {
  name       = "desafio-globo-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.desafio_globo.name
  node_count = 3

  node_config {
    machine_type = "n1-standard-1"
    disk_size_gb = 32

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # service_account = google_service_account.default.email
    # oauth_scopes    = [
    #   "https://www.googleapis.com/auth/cloud-platform"
    # ]
  }
}


data "google_client_config" "default" {}

# provider "kubernetes" {

#   host                   = "https://${google_container_cluster.desafio_globo.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(google_container_cluster.desafio_globo.master_auth[0].cluster_ca_certificate)

#   # client_certificate     = base64decode(google_container_cluster.desafio_globo.master_auth.0.client_certificate)
#   # client_key             = base64decode(google_container_cluster.desafio_globo.master_auth.0.client_key)
#   # cluster_ca_certificate = base64decode(google_container_cluster.desafio_globo.master_auth.0.cluster_ca_certificate)
# }
