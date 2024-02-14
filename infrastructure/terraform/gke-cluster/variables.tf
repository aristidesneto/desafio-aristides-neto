variable "project_id" {
  type        = string
  description = "ID do projeto no GCP"
  default     = "lab-terraform-414113"
}

variable "region" {
  type        = string
  description = "Região do projeto GCP"
  default     = "us-central1"
}

variable "zone" {
  type        = string
  description = "Zona do projeto GCP"
  default     = "us-central1-a"
}

variable "cluster_name" {
  type        = string
  description = "Nome do cluster GKE"
  default     = "desafio-globo-gke"
}