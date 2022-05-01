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

resource "aws_instance" "ec2-public" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.sub-public.id
  key_name = "gabriel-aws"
  security_groups = [aws_security_group.allow-ssh.id]
  lifecycle {
    ignore_changes = [security_groups]
  }
  tags = {
      Name = "ec2 publica"
  }
}

resource "aws_security_group" "allow-ssh" {
    name = "allow-ssh"
    description = "allow-ssh"
    vpc_id = aws_vpc.vpc_gabriel.id

    tags = {
        Name = "permitir acesso via ssh"
    }
}

resource "aws_security_group_rule" "ssh-conection-ingress" {
  type = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 22
  to_port = 22
  protocol = "tcp"
  security_group_id = aws_security_group.allow-ssh.id
}

resource "aws_security_group_rule" "ssh-connection-egress" {
  type = "egress"
  cidr_blocks = ["0.0.0.0/0"]
  from_port = 0
  to_port = 0
  protocol = "-1"
  security_group_id = aws_security_group.allow-ssh.id
}

resource "aws_instance" "ec2-private" {
  ami = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.sub-private.id
  key_name = "gabriel-aws"
  security_groups = [aws_security_group.allow-ssh.id]
  lifecycle {
    ignore_changes = [security_groups]
  }
  tags = {
      Name = "ec2 privada"
  }
}

