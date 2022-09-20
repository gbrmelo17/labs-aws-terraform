#CRIANDO O CLUSTER
resource "aws_ecs_cluster" "cluster-teste" {
  name = format("ecs-cluster-teste-%s", var.enviroment)
}