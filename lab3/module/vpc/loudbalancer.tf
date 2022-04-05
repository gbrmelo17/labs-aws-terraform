resource "aws_launch_configuration" "launch-aws-configuration" {
  image_id = var.ami
  instance_type = var.instance-type
  security_groups = [aws_security_group.launch-configuration-sg.id]
  key_name = var.key-name
  //user_data = file("data.sh")
  

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "scalling-group" {
  name = "scalling group ec2"
  min_size = 2
  max_size = 2
  desired_capacity = 2
  health_check_type = "ELB"
  load_balancers = [aws_elb.loud-balancer.id]



launch_configuration = aws_launch_configuration.launch-aws-configuration.id

enabled_metrics = [
"GroupMinSize", 
    "GroupMaxSize", 
    "GroupDesiredCapacity", 
    "GroupInServiceInstances", 
    "GroupTotalInstances"
]

metrics_granularity = "1Minute"

vpc_zone_identifier = [aws_subnet.public-subnets[0].id]

lifecycle {
  create_before_destroy = true
}

tag {
  key = var.key-name
  value = "web"
  propagate_at_launch = true
}

}

resource "aws_security_group" "launch-configuration-sg" {
  name = "launch-templete-sg"
  vpc_id = aws_vpc.vpc.id
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

resource "aws_elb" "loud-balancer" {
  name = "loud-balancer"
  subnets = [aws_subnet.public-subnets[0].id]
  security_groups = [aws_security_group.loud-balancer-sg.id]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
  }
}

resource "aws_security_group" "loud-balancer-sg" {
  vpc_id = aws_vpc.vpc.id
  name = "loud balancer security group"
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
