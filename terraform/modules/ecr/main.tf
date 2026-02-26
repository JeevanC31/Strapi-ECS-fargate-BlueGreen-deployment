resource "aws_ecr_repository" "this" {
  name = "strapi-bluegreen"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}