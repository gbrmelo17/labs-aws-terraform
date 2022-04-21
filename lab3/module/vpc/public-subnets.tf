resource "aws_subnet" "public_subnets" {
  vpc_id = aws_vpc.vpc_id.id
  count = length(var.public_subnets)
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.zones[count.index]
  map_public_ip_on_launch = true
  tags = {
      Name = format("public-subnet-${count.index}-%s", var.enviroment)
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_id.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
      Name = format("rt-public-%s", var.enviroment)
  }
}

resource "aws_route_table_association" "rt_public_asso" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.rt_public.id
}