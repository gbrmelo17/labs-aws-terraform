variable "enviroment" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "enabled_metrics" {
  type = list(any)
}

variable "metrics_granularity" {
  type = string
}

variable "instance_port" {
  type = number
}

variable "instance_protocol" {
  type = string
}


variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "asg_subnets" {
  type = list(any)
}

variable "lb_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}

