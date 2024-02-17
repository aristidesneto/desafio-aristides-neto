resource "google_artifact_registry_repository" "comments-api" {
  location      = "us-central1"
  repository_id = "comments-api"
  description   = "Comments API repository"
  format        = "DOCKER"
}