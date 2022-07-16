resource "aws_instance" "ec2teste" {
  ami = var.ami
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = var.subnet_id
  security_groups = [aws_security_group.allow-protocol.id]
  //user_data = file("data.sh")

  tags = {
    Name = "ec2 teste"
  }
}

resource "aws_security_group" "allow-protocol" {
  name = "allow-protocol"
  description = "allow-protocol"
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
