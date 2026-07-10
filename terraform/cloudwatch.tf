data "aws_cloudwatch_log_group" "eks_cluster" {
  name = "/aws/eks/${var.cluster_name}/cluster"
}
