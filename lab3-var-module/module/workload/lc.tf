resource "aws_launch_configuration" "lc" {
  name_prefix = format("lc-%s", var.enviroment)
  image_id = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  security_groups = [aws_security_group.lc_sg.id]

  user_data = base64encode(templatefile("${path.module}/user_data.tpl",{ img_repo = var.img_repo, img_tag = var.img_tag}))

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lc_sg" {
  name_prefix = format("lc-sg-%s", var.enviroment)
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
}