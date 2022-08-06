resource "kubernetes_namespace" "watcher" {
  metadata {}
}
resource "kubernetes_namespace" "nginx-ingress" {
  metadata {}
}
resource "kubernetes_namespace" "cert-manager" {
  metadata {}
}
