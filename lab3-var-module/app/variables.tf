variable "enviroment" {
  type = string
}

variable "private_subnets" {
  type = list(any)
}

variable "zones" {
  type = list(any)
}

variable "public_subnets" {
  type = list(any)
}

variable "vpc_id" {
  type = string
}