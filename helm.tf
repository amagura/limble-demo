resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts/"
  chart      = "prometheus"
  namespace  = "watcher"
}

resource "helm_release" "alert-manager" {
  name        = "alert-manager"
  repository  = "https://prometheus-community.github.io/helm-charts/"
  chart       = "alert-manager"
  namespace   = "watcher"
}

resource "helm_release" "nginx-ingress" {
  name        = "nginx-ingress"
  repository  = "https://kubernetes.github.io/ingress-nginx/"
  chart       = "ingress-nginx"
  namespace   = "nginx-ingress"

  set {
    name      = "service.type"
    value     = "ClusterIP"
  }
  set {
    name      = "controller.metrics.enabled"
    value     = true
  }
  set {
    name      = "controller.metrics.serviceMonitor.enabled"
    value     = true
  }
}

resource "helm_release" "cert-manager" {
  name        = "cert-manager"
  repository  = "https://charts.jetstack.io"
  chart       = "cert-manager"
  version     = "v1.9.1"
  namespace   = "cert-manager"
  # values      = [file("values/cm.yml")]

  set {
    name  = "prometheus.enabled"
    value = true
  }
  set {
    name  = "installCRDS"
    value = true
  }
}

resource "helm_release" "npd" {
  name        = "npd"
  repository  = "https://charts.deliveryhero.io/"
  chart       = "node-problem-detector"
  namespace   = "watcher"

  set {
    name  = "metrics.enabled"
    value = true
  }
}

resource "helm_release" "grafana" {
  name        = "grafana"
  repository  = "https://grafana.github.io/helm-charts/"
  chart       = "grafana"
  namespace   = "watcher"

  # set {
  #   name  = "serviceMonitor.enabled"
  #   value = true
  # }
}
