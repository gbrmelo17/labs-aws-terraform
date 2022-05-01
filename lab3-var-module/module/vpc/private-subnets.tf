resource "aws_subnet" "private_subnets" {
  vpc_id = aws_vpc.vpc_id.id
  count = length(var.private_subnets)
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.zones[count.index]
  tags = {
      Name = format("private-subnet-${count.index}-%s", var.enviroment)
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_id.id
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
      Name = format("rt-private-%s", var.enviroment)
  }
}

resource "aws_route_table_association" "rt_private_asso" {
  count = length(var.private_subnets)
  subnet_id = aws_subnet.private_subnets[count.index].id 
  route_table_id = aws_route_table.rt_private.id
}