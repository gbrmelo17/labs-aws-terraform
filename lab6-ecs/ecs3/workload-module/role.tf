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