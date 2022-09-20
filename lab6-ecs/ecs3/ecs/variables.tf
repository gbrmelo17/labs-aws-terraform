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

variable "network_mode" {
  type = string
}

variable "memory" {
  type = string
}

variable "cpu" {
  type = string
}

variable "requires_compatibilities" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "launch_type" {
  type = string
}


