variable "project_name" {
  description = "Nombre del proyecto usado en etiquetas y recursos"
  type        = string
  default     = "docker-testing"
}

variable "aws_region" {
  description = "Region de AWS donde se despliega la infraestructura"
  type        = string
}

variable "cluster_name" {
  description = "Nombre del cluster EKS"
  type        = string
  default     = "docker-testing-eks"
}

variable "cluster_version" {
  description = "Version de Kubernetes para EKS"
  type        = string
  default     = "1.29"
}

variable "vpc_cidr" {
  description = "CIDR block de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "node_instance_type" {
  description = "Tipo de instancia para el node group"
  type        = string
  default     = "t3.small"
}

variable "desired_nodes" {
  description = "Numero deseado de nodos worker"
  type        = number
  default     = 2
}

variable "min_nodes" {
  description = "Numero minimo de nodos worker"
  type        = number
  default     = 1
}

variable "max_nodes" {
  description = "Numero maximo de nodos worker"
  type        = number
  default     = 2
}

variable "log_retention_days" {
  description = "Dias de retencion de logs en CloudWatch"
  type        = number
  default     = 7
}
