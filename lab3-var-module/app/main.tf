module "vpc" {
  source = "../module/vpc/"
  vpc_id = var.vpc_id
public_subnets = var.public_subnets
private_subnets = var.private_subnets
zones = var.zones
enviroment = var.enviroment
}