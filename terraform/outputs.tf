output "aws_region" {
  description = "Region de AWS utilizada"
  value       = var.aws_region
}

output "aws_account_id" {
  description = "ID de la cuenta AWS"
  value       = data.aws_caller_identity.current.account_id
}

output "cluster_name" {
  description = "Nombre del cluster EKS"
  value       = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  description = "Endpoint del API server de EKS"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Certificado CA del cluster EKS"
  value       = aws_eks_cluster.main.certificate_authority[0].data
  sensitive   = true
}

output "ecr_api_repository_url" {
  description = "URL del repositorio ECR de la API"
  value       = data.aws_ecr_repository.api.repository_url
}

output "ecr_frontend_repository_url" {
  description = "URL del repositorio ECR del frontend"
  value       = data.aws_ecr_repository.frontend.repository_url
}

output "vpc_id" {
  description = "ID de la VPC"
  value       = data.aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs de las subnets publicas"
  value       = data.aws_subnets.public.ids
}

output "cloudwatch_log_group_name" {
  description = "Nombre del log group de CloudWatch para EKS"
  value       = data.aws_cloudwatch_log_group.eks_cluster.name
}
