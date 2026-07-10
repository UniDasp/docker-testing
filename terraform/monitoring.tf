resource "helm_release" "kube_prometheus_stack" {
  count            = var.manage_monitoring_stack ? 1 : 0
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  timeout = 900
  wait    = true

  lifecycle {
    ignore_changes = all
  }

  depends_on = [
    aws_eks_node_group.main
  ]
}
