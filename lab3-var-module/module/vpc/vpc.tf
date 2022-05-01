resource "aws_vpc" "vpc_id" {
  cidr_block = var.vpc_id
  tags = {
      Name = format("vpc-%s", var.enviroment)
  }
}
