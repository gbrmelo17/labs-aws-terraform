#####NECESSARY#####

variable "vpc-cidr" {
  type = string
}

variable "public-subnets" {
  type = list(any)
}

variable "private-subnets" {
  type = list(any)
}

variable "zones" {
  type = list(any)
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "ami" {
  type = string
}

variable "instance-type" {
  type = string
}

variable "key-name" {
  type = string
}