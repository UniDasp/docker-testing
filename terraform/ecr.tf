data "aws_ecr_repository" "api" {
  name = "${var.project_name}-api"
}

data "aws_ecr_repository" "frontend" {
  name = "${var.project_name}-frontend"
}

data "aws_ecr_repository" "db" {
  name = "${var.project_name}-db"
}

resource "aws_ecr_repository" "api" {
  count = length(data.aws_ecr_repository.api.id) > 0 ? 0 : 1

  name                 = "${var.project_name}-api"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "frontend" {
  count = length(data.aws_ecr_repository.frontend.id) > 0 ? 0 : 1

  name                 = "${var.project_name}-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "db" {
  count = length(data.aws_ecr_repository.db.id) > 0 ? 0 : 1

  name                 = "${var.project_name}-db"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "api" {
  count = length(data.aws_ecr_repository.api.id) > 0 ? 0 : 1

  repository = aws_ecr_repository.api[0].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "frontend" {
  count = length(data.aws_ecr_repository.frontend.id) > 0 ? 0 : 1

  repository = aws_ecr_repository.frontend[0].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "db" {
  count = length(data.aws_ecr_repository.db.id) > 0 ? 0 : 1

  repository = aws_ecr_repository.db[0].name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 10
      }
      action = {
        type = "expire"
      }
    }]
  })
}
