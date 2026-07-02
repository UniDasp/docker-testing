data "aws_eks_cluster" "main" {
  name = var.cluster_name
}

data "aws_eks_node_group" "main" {
  cluster_name    = data.aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-nodes"
}
