#CRIAÇÃO DA ROLE DE EC2 PARA UTILIZAR OS CONTAINERS
resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role"
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
  role = "${aws_iam_role.ecs-instance-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#CRIANDO PROFILE PARA UTILIZAÇÃO DA ROLE 
resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role.name
  provisioner "local-exec" {
    command = "sleep 60"
  }
}

#CRIAÇÃO DA ROLE PARA O ECS UTILIZAR OS CONTAINERS
resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-service-role"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-policy.json
}

#FUNÇÃO DA ROLE (QUEM VAI PODER ASSUMIR A ROLE? APENAS SERVIÇOS DO TIPO ECS)
data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = [
      "sts:AssumeRole"
      ]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

#LIGANDO A ROLE NA POLICY (NESSE CASO UTILIZANDO UMA POLICY JA EXISTENTE DA AWS DE EC2 PARA CONTAINERS)
resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role = "${aws_iam_role.ecs-service-role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

#CRIANDO O CLUSTER
resource "aws_ecs_cluster" "cluster-teste" {
  name = "ecs-cluster-teste"
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values =  ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"] 
  }
}

#ECS AGENT
resource "aws_instance" "ecs-agent" {
  ami             = data.aws_ami.ecs_ami.id
  instance_type   = "t3.medium"
  subnet_id       = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  security_groups = [aws_security_group.ecs-sg.id]
  key_name        = "gabriel-ec2"
  user_data       = "${data.template_file.user_data.rendered}"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ebs_block_device,
      security_groups
    ]
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"
  vars = {
    ecs_cluster = "ecs-cluster-teste"
  }
}

resource "aws_security_group" "ecs-sg" {
  name = "ecs-sg"
  description = "ecs-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#ECS TASK DEFINITION
resource "aws_ecs_task_definition" "task_definition" {
  container_definitions = "${data.template_file.task_definition_json.rendered}"
  family = "ecs-task-definition"
  network_mode = "bridge"
  memory = "512"
  cpu = "256"
  requires_compatibilities = ["EC2"]
}

data "template_file" "task_definition_json" {
  template = "${file("${path.module}/task_definition.json")}"
}

resource "aws_ecs_service" "service" {
  cluster = aws_ecs_cluster.cluster-teste.id
  desired_count = 1
  launch_type = "EC2"
  name = "cluster-teste"
  task_definition = aws_ecs_task_definition.task_definition.id

 //network_configuration {
   // security_groups = [aws_security_group.ecs-sg.id]
    //subnets = [data.terraform_remote_state.vpc.outputs.public_subnets[0]]
  //}
}