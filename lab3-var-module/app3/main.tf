module "instace" {
  source = "../module/ec2/"
  key_name = var.key_name
  ami = var.ami
  instance_type = var.instance_type
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc
  subnet_id = data.terraform_remote_state.vpc.outputs.public_subnets[0]
  
}
 # teste cicd