data "aws_cloudwatch_log_group" "eks_cluster" {
  name = "/aws/eks/${var.cluster_name}/cluster"
}

resource "aws_cloudwatch_log_group" "eks_cluster" {
  count = length(data.aws_cloudwatch_log_group.eks_cluster.id) > 0 ? 0 : 1

  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = var.log_retention_days
}
