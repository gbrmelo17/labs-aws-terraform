resource "aws_vpc" "vpc_gabriel" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc_gabriel.id
}

resource "aws_eip" "nat-gateway-eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id = aws_subnet.sub-public.id

  tags = {
      Name = "nat gateway"
  }
}

resource "aws_subnet" "sub-public" {
  vpc_id = aws_vpc.vpc_gabriel.id
  cidr_block = "10.1.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
      Name = "subnet publica"
  }
}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc_gabriel.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internet-gateway.id
  }
}

resource "aws_route_table_association" "rt-public-association" {
    subnet_id = aws_subnet.sub-public.id
    route_table_id = aws_route_table.rt-public.id
}

resource "aws_subnet" "sub-private" {
  vpc_id = aws_vpc.vpc_gabriel.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
      Name = "subnet privada"
  }
}

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.vpc_gabriel.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
}

resource "aws_route_table_association" "rt-private-association" {
  subnet_id = aws_subnet.sub-private.id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_launch_configuration" "launch-aws-configuration" {
  image_id = "ami-0c7e0082eed87cb83"
  instance_type = "t2.micro"
  security_groups = [aws_security_group.launch-configuration-sg.id]
  key_name = "gabriel-aws"
  user_data = file("data.sh")
  

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

vpc_zone_identifier = [aws_subnet.sub-public.id]

lifecycle {
  create_before_destroy = true
}

tag {
  key = "gabriel-aws"
  value = "web"
  propagate_at_launch = true
}

}

resource "aws_security_group" "launch-configuration-sg" {
  name = "launch-templete-sg"
  vpc_id = aws_vpc.vpc_gabriel.id
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
  subnets = [aws_subnet.sub-public.id]
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
  vpc_id = aws_vpc.vpc_gabriel.id
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

/*
resource "aws_instance" "ec2teste" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t2.micro"
  key_name = "gabriel-aws"
  subnet_id = aws_subnet.sub-public.id
  security_groups = [aws_security_group.allow-protocol.id]
  user_data = file("data.sh")

  tags = {
    Name = "ec2 teste"
  }
}

resource "aws_security_group" "allow-protocol" {
  name = "allow-protocol"
  description = "allow-protocol"
  vpc_id = aws_vpc.vpc_gabriel.id

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
*/