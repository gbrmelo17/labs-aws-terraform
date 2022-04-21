resource "aws_elb" "lb" {
  name_prefix = format("lb-%s", var.enviroment)
  subnets = var.lb_subnets
  security_groups = [aws_security_group.lb_sg.id]

  listener {
    instance_port = var.instance_port
    instance_protocol = var.instance_protocol
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = format("HTTP:%s/", var.instance_port)
    interval = 30
  }
}

resource "aws_security_group" "lb_sg" {
  name_prefix = format("lb-sg-%s", var.enviroment)
  vpc_id = var.vpc_id

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

  lifecycle {
    create_before_destroy = true
  }
}