module "lb" {
  source = "../module/workload/"
  enviroment = var.enviroment
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  enabled_metrics = var.enabled_metrics
  metrics_granularity = var.metrics_granularity
  key_name = var.key_name
  instance_port = var.instance_port
  ami = var.ami
  instance_type = var.instance_type
  instance_protocol = var.instance_protocol
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc
  asg_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  lb_subnets = data.terraform_remote_state.vpc.outputs.public_subnets
  img_repo = var.img_repo
  img_tag = var.img_tag
}

#testando cicd teste 1ss

