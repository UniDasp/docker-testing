locals {
  common_tags = {
    Project     = var.project_name
    ManagedBy   = "terraform"
    Environment = "dev"
  }

  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}
