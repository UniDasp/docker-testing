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

data "aws_autoscaling_group" "eks_nodes" {
  count = length(data.aws_eks_node_group.main.id) > 0 ? 0 : 1

  filter {
    name   = "tag:eks:nodegroup-name"
    values = ["${var.project_name}-nodes"]
  }

  filter {
    name   = "tag:eks:cluster-name"
    values = [var.cluster_name]
  }

  depends_on = [aws_eks_node_group.main]
}

resource "aws_autoscaling_policy" "cpu_scale_up" {
  count = length(data.aws_eks_node_group.main.id) > 0 ? 0 : 1

  name                   = "${var.project_name}-cpu-scale-up"
  autoscaling_group_name = data.aws_autoscaling_group.eks_nodes[0].name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300

  depends_on = [data.aws_autoscaling_group.eks_nodes]
}

resource "aws_autoscaling_policy" "cpu_scale_down" {
  count = length(data.aws_eks_node_group.main.id) > 0 ? 0 : 1

  name                   = "${var.project_name}-cpu-scale-down"
  autoscaling_group_name = data.aws_autoscaling_group.eks_nodes[0].name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300

  depends_on = [data.aws_autoscaling_group.eks_nodes]
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  count = length(data.aws_eks_node_group.main.id) > 0 ? 0 : 1

  alarm_name          = "${var.project_name}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 70
  alarm_actions       = [aws_autoscaling_policy.cpu_scale_up[0].arn]

  dimensions = {
    AutoScalingGroupName = data.aws_autoscaling_group.eks_nodes[0].name
  }

  depends_on = [aws_autoscaling_policy.cpu_scale_up]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  count = length(data.aws_eks_node_group.main.id) > 0 ? 0 : 1

  alarm_name          = "${var.project_name}-cpu-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 30
  alarm_actions       = [aws_autoscaling_policy.cpu_scale_down[0].arn]

  dimensions = {
    AutoScalingGroupName = data.aws_autoscaling_group.eks_nodes[0].name
  }

  depends_on = [aws_autoscaling_policy.cpu_scale_down]
}
