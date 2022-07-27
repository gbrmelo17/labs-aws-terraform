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

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "img_repo" {
  type = string
}

variable "img_tag" {
  type = string
}