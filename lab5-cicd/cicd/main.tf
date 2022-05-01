resource "aws_instance" "github_runner" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  security_groups = [aws_security_group.sg_github_actions.id]
  key_name        = var.key_name
  user_data       = templatefile("user_data.tpl", { hash = var.hash, token = var.token, name_runner = var.name_runner })

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