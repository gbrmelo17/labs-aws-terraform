resource "aws_subnet" "public-subnets" {
  count = length(var.public-subnets)
  vpc_id = aws_vpc.vpc.id
  cidr_block = var.public-subnets[count.index]
  availability_zone = var.zones[count.index]
  map_public_ip_on_launch = true

  tags = {
      Name = format("%s-public-${substr(element(var.zones, count.index), 8, 10)}", var.environment)
  }
}



resource "aws_route_table_association" "rt-public-association" {
  count = length(var.public-subnets)
    subnet_id = aws_subnet.public-subnets[count.index].id
    route_table_id = aws_route_table.rt-public.id
}