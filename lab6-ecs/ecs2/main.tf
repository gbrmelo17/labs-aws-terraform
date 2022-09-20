#CRIAÇÃO DA ROLE DE EC2 PARA UTILIZAR OS CONTAINERS
resource "aws_iam_role" "ecs-instance-role1" {
  name = "ecs-instance-role1"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json
}

#FUNÇAO DA ROLE (QUEM VAI PODER ASSUMIR A ROLE? APENAS SERVIÇOS DO TIPO EC2)
data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {

    actions = [
      "sts:AssumeRole"
      ]

    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#LIGANDO A ROLE NA POLICY (NESSE CASO UTILIZANDO UMA POLICY JA EXISTENTE DA AWS DE EC2 PARA CONTAINERS)
resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role = "${aws_iam_role.ecs-instance-role1.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#CRIANDO PROFILE PARA UTILIZAÇÃO DA ROLE 
resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role1.name
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

#CRIANDO O CLUSTER
resource "aws_ecs_cluster" "cluster-teste" {
  name = format("ecs-cluster-teste-%s", var.enviroment)
}

//subnet_id       = data.terraform_remote_state.vpc.outputs.public_subnets[0]

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

#ECS SERVICE
resource "aws_ecs_service" "service" {
  cluster = aws_ecs_cluster.cluster-teste.id
  desired_count = var.desired_count
  launch_type = var.launch_type
  name = format("cluster-teste-%s", var.enviroment)
  task_definition = aws_ecs_task_definition.task_definition.id
  depends_on = [aws_elb.lb]
}