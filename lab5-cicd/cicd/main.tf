resource "aws_instance" "github_runner" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  security_groups = [aws_security_group.sg_github_actions.id]
  key_name        = var.key_name
  user_data       = templatefile("user_data.tpl", { hash = var.hash, token = var.token, name_runner = var.name_runner })
  iam_instance_profile = aws_iam_instance_profile.runner_profile.name

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ebs_block_device,
      security_groups
    ]
  }

  tags = {
    "Name"        = format("github_runner-%s", var.environment)
    "Environment" = var.environment
  }
}

# ASSUME ROLE POLICY - SERVIÇO QUE IRA UTILIZAR A ROLE
data "aws_iam_policy_document" "runner_iam_assume_policy" {
  statement {

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

#ROLE
resource "aws_iam_role" "runner_role" {
  name               = "runner_role"
  assume_role_policy = data.aws_iam_policy_document.runner_iam_assume_policy.json
}


#ROLE POLICY - PERMISSÕES DA ROLE
data "aws_iam_policy_document" "runner_iam_policy" {
  statement {
    effect = "Allow"

    actions = [
      "*"
    ]

    resources = [
      "*"
    ]
  }
}

#POLICY
resource "aws_iam_policy" "runner_policy" {
  name   = "runner_policy"
  path   = "/"
  policy = data.aws_iam_policy_document.runner_iam_policy.json
}

#ATTATCHMENT
resource "aws_iam_policy_attachment" "runner_attach" {
  name       = "runner-attachment"
  roles      = [aws_iam_role.runner_role.name]
  policy_arn = aws_iam_policy.runner_policy.arn
}

#PROFILE
resource "aws_iam_instance_profile" "runner_profile" {
  name = "runner_profile"
  role = aws_iam_role.runner_role.name
}

resource "aws_security_group" "sg_github_actions" {
  name        = format("github-actions-%s", var.environment)
  description = "Allow traffic for github actions runner"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name          = format("github-actions-%s", var.environment)
    "Environment" = var.environment
  }
}

resource "aws_security_group_rule" "allow_80" {
  type              = "ingress"
  description       = "allow http"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_github_actions.id
}

resource "aws_security_group_rule" "allow_443" {
  type              = "ingress"
  description       = "allow https"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_github_actions.id
}

resource "aws_security_group_rule" "allow_22" {
  type              = "ingress"
  description       = "allow ssh for my network"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["191.47.232.118/32"]
  security_group_id = aws_security_group.sg_github_actions.id
}