module "vpc" {
  source = "../module/vpc"
  vpc-cidr = var.vpc-cidr
  public-subnets = var.public-subnets
  private-subnets = var.private-subnets
  zones = var.zones
  environment = var.environment
  region = var.region
  ami = var.ami
  instance-type = var.instance-type
  key-name = var.key-name
  
}