data "aws_iam_role" "eks_cluster" {
  name = "LabRole"
}

data "aws_iam_role" "eks_nodes" {
  name = "LabRole"
}
