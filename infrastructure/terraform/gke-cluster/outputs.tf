output "region" {
  value       = var.region
  description = "Região GCP"
}

output "zone" {
  value       = var.zone
  description = "Zona GCP"
}

output "project_id" {
  value       = var.project_id
  description = "Id do projeto GCP"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.desafio_globo.name
  description = "Nome do cluster GKE"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.desafio_globo.endpoint
  description = "Host do cluster GKE"
}