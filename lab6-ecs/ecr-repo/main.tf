#CRIAÇÃO DO REPOSITORIO ECR DAS IMGS
resource "aws_ecr_repository" "nginx-teste" {
  name = "nginx-teste"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
