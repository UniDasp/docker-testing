data "helm_release" "kube_prometheus_stack" {
  name      = "kube-prometheus-stack"
  namespace = "monitoring"
}
