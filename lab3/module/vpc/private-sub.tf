resource "aws_subnet" "private-subnets" {
  count = length(var.private-subnets)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.private-subnets[count.index]
  availability_zone = var.zones[count.index]

  tags = {
      Name = format("%s-private-${substr(element(var.zones, count.index), 8, 10)}", var.environment)
  }
}

resource "aws_route_table_association" "rt-private-association" {
  count = length(var.private-subnets)
  subnet_id = aws_subnet.private-subnets[count.index].id
  route_table_id = aws_route_table.rt-private.id
}