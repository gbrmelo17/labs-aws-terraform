module "workload" {
  source = "../workload-module"
  enviroment = var.enviroment
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  enabled_metrics = var.enabled_metrics
  metrics_granularity = var.metrics_granularity
  key_name = var.key_name
  instance_port = var.instance_port
  instance_type = var.instance_type
  instance_protocol = var.instance_protocol
  asg_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  lb_subnets = data.terraform_remote_state.vpc.outputs.public_subnets
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc
}

module "ecs" {
  source = "../ecs-module"
  network_mode = var.network_mode
  memory = var.memory
  cpu = var.cpu
  requires_compatibilities = var.requires_compatibilities
  desired_count = var.desired_count
  launch_type = var.launch_type
  enviroment = var.enviroment
}






