data "aws_eks_cluster" "main" {
  name = var.cluster_name
}

data "aws_eks_node_group" "main" {
  cluster_name    = data.aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-nodes"
}

resource "aws_eks_cluster" "main" {
  count = length(data.aws_eks_cluster.main.id) > 0 ? 0 : 1

  name     = var.cluster_name
  role_arn = data.aws_iam_role.lab_role.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = length(data.aws_subnets.public.ids) > 0 ? data.aws_subnets.public.ids : aws_subnet.public[*].id
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_cloudwatch_log_group.eks_cluster
  ]
}

resource "aws_eks_node_group" "main" {
  count = length(data.aws_eks_node_group.main.id) > 0 ? 0 : 1

  cluster_name    = aws_eks_cluster.main[0].name
  node_group_name = "${var.project_name}-nodes"
  node_role_arn   = data.aws_iam_role.lab_role.arn
  subnet_ids      = length(data.aws_subnets.public.ids) > 0 ? data.aws_subnets.public.ids : aws_subnet.public[*].id

  scaling_config {
    desired_size = var.desired_nodes
    min_size     = var.min_nodes
    max_size     = var.max_nodes
  }

  instance_types = [var.node_instance_type]

  labels = {
    "node-type" = "general-purpose"
  }
}

