resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc_id.id
  tags = {
      Name = format("ig-%s", var.enviroment)
  }
}