variable "project_name" {
  type    = string
  default = "docker-testing"
}

variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "docker-testing-eks"
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}

variable "desired_nodes" {
  type    = number
  default = 2
}

variable "min_nodes" {
  type    = number
  default = 1
}

variable "max_nodes" {
  type    = number
  default = 2
}

variable "log_retention_days" {
  type    = number
  default = 7
}

variable "manage_monitoring_stack" {
  type    = bool
  default = false
}
