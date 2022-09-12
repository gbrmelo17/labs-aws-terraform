resource "aws_autoscaling_group" "asg" {
  min_size = var.min_size
  max_size = var.max_size
  desired_capacity = var.desired_capacity
  health_check_type = "ELB"
  load_balancers = [aws_elb.lb.id]
  launch_configuration = aws_launch_configuration.lc.id
  enabled_metrics = var.enabled_metrics
  metrics_granularity = var.metrics_granularity
  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.private_subnets

  lifecycle {
    create_before_destroy = true
  }
  
}