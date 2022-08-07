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

provider "kubectl" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  config_path            = "~/.kube/config"
}

# resource "kubectl_manifest" "certissuer" {
#   yaml_body = file("certissuer.yaml")
# }
