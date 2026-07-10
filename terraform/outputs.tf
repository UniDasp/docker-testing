output "aws_region" {
  value = var.aws_region
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "cluster_name" {
  value = data.aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = data.aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  value     = data.aws_eks_cluster.main.certificate_authority[0].data
  sensitive = true
}

output "ecr_api_repository_url" {
  value = data.aws_ecr_repository.api.repository_url
}

output "ecr_frontend_repository_url" {
  value = data.aws_ecr_repository.frontend.repository_url
}

output "ecr_db_repository_url" {
  value = data.aws_ecr_repository.db.repository_url
}

output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

output "cloudwatch_log_group_name" {
  value = data.aws_cloudwatch_log_group.eks_cluster.name
}
