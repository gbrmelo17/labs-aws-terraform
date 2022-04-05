resource "aws_eip" "nat-gateway-eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = aws_eip.nat-gateway-eip.id
  subnet_id = aws_subnet.public-subnets[0].id

  tags = {
      Name = format("nat gateway %s", var.environment)
  }
}

resource "aws_route_table" "rt-private" {
  vpc_id = aws_vpc.vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat-gateway.id
  }
}

