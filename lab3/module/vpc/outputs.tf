output "vpc-id" {
value = aws_vpc.vpc.id  
}

output "public-subnets" {
  value = aws_subnet.public-subnets[*].id
}

output "private-subnets" {
  value = aws_subnet.private-subnets[*].id
}