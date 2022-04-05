resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "rt-public" {
  vpc_id = aws_vpc.vpc.id
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.internet-gateway.id
  }
//tags {
  //Name = format("%s-rt-public", var.environment)
//}
}