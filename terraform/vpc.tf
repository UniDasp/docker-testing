data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-vpc"]
  }
}

data "aws_internet_gateway" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-igw"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-public-*"]
  }
}

data "aws_route_table" "public" {
  filter {
    name   = "tag:Name"
    values = ["${var.project_name}-public-rt"]
  }
}
