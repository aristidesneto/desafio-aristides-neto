# provider "kubernetes" {
#   host                   = "https://${google_container_cluster.desafio_globo.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(google_container_cluster.desafio_globo.master_auth[0].cluster_ca_certificate)
# }

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.desafio_globo.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.desafio_globo.master_auth[0].cluster_ca_certificate)
  }
}

# Install ArgoCD
resource "helm_release" "argocd" {
  depends_on = [google_container_node_pool.desafio_globo_nodes]
  name       = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "6.0.11"

  values = [
    file("helm_values/argocd-overrides.yaml")
  ]
}

# Install Kube Prometheus Stack
resource "helm_release" "kube_stack_prometheus" {
  depends_on = [google_container_node_pool.desafio_globo_nodes]
  name       = "kube-stack-prometheus"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "prometheus"
  create_namespace = true
  version          = "56.6.2"
  wait             = false

  values = [
    file("helm_values/kube-prometheus-stack-overrides.yaml")
  ]
}

resource "helm_release" "grafana_loki" {
  depends_on = [google_container_node_pool.desafio_globo_nodes]
  name       = "grafana-loki"

  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  namespace        = "loki"
  create_namespace = true
  version          = "5.43.1"
  wait             = false
  timeout          = 3000

  # values = [
  #   file("helm_values/loki-overrides.yaml")
  # ]
}

resource "helm_release" "grafana_promtail" {
  depends_on = [helm_release.grafana_loki]
  name       = "grafana-promtail"

  repository       = "https://grafana.github.io/helm-charts"
  chart            = "promtail"
  namespace        = "loki"
  create_namespace = true
  version          = "6.15.5"
  wait             = false

  values = [
    file("helm_values/promtail-overrides.yaml")
  ]
}


resource "helm_release" "install_comments_api" {
  depends_on = [helm_release.argocd]
  name       = "argocd-apps"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-apps"
  namespace        = "argocd"
  create_namespace = true
  version          = "1.6.1"
  wait             = false

  values = [
    file("argocd_apps/comments-api.yaml")
  ]
}