#ECS SERVICE
resource "aws_ecs_service" "service" {
  cluster = aws_ecs_cluster.cluster-teste.id
  desired_count = var.desired_count
  launch_type = var.launch_type
  name = format("cluster-teste-%s", var.enviroment)
  task_definition = aws_ecs_task_definition.task_definition.id
  depends_on = [aws_elb.lb]
}