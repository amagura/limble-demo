provider "kubernetes" {
  config_path     = "~/.kube/config"
  config_context  = "my-context"
}

resource "kubernetes_namespace" "watcher" {
  metadata {}
}
resource "kubernetes_namespace" "nginx-ingress" {
  metadata {}
}
resource "kubernetes_namespace" "cert-manager" {
  metadata {}
}
