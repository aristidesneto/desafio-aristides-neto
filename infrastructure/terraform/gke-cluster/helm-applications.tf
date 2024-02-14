# # provider "helm" {
# #   kubernetes {
# #     config_path = "~/.kube/config"
# #   }
# # }

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

  name = "argocd"

  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "6.0.11"

  values = [
    file("helm_values/argocd.yaml")
  ]
}

# resource "kubernetes_namespace" "api_dev" {
#   depends_on = [helm_release.argocd]
#   metadata {
#     name = "api-dev"
#   }
# }

# resource "kubectl_manifest" "install_comments_api_dev" {
#   depends_on        = [kubernetes_namespace.api_dev]
#   yaml_body         = file("argocd_apps/comments-api-dev.yaml")
#   wait              = true
#   server_side_apply = true
# }

# Install Kube Prometheus Stack
resource "helm_release" "kube_stack_prometheus" {
  depends_on = [google_container_node_pool.desafio_globo_nodes]
  name       = "kube-stack-prometheus"

  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "prometheus"
  create_namespace = true
  version          = "56.6.2"

  values = [
    file("helm_values/kube-prometheus-stack.yaml")
  ]
}

resource "helm_release" "install_comments_api_dev" {
  depends_on = [helm_release.argocd]
  chart      = "argocd-apps"
  name       = "argocd-apps"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  values = [
    file("argocd_apps/comments-api-dev.yaml")
  ]
}