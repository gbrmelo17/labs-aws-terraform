#ECS TASK DEFINITION
resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = "${data.template_file.task_definition_json.rendered}"
  family = format("ecs-task-definition-%s", var.enviroment)
  network_mode = var.network_mode
  memory = var.memory
  cpu = var.cpu
  requires_compatibilities = [var.requires_compatibilities]
}

data "template_file" "task_definition_json" {
  template = "${file("${path.module}/task_definition.json")}"
}