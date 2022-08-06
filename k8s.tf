resource "kubernetes_namespace" "watcher" {
  metadata {
    name = "watcher"
  }
}
resource "kubernetes_namespace" "nginx-ingress" {
  metadata {
    name = "nginx-ingress"
  }
}
resource "kubernetes_namespace" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}
