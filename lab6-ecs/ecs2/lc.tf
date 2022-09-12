resource "aws_launch_configuration" "lc" {
  image_id = data.aws_ami.ecs_ami.id
  instance_type = var.instance_type 
  key_name = var.key_name
  security_groups = [aws_security_group.lc_sg.id]
  user_data = "${data.template_file.user_data.rendered}"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name
  

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      ebs_block_device,
      security_groups
    ]
  }
}

resource "aws_security_group" "lc_sg" {
  name_prefix = format("lc-sg-%s", var.enviroment)
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

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.tpl")}"
  vars = {
    ecs_cluster = "ecs-cluster-teste"
  }
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values =  ["amzn2-ami-ecs-hvm-2.0.*-x86_64-ebs"] 
  }
}





  
  