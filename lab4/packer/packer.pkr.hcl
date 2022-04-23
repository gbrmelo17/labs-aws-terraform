packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "aws_access_key" {
  type = string
  default = ""
}

variable "aws_secret_key" {
  type = string
  default = ""
}


variable "sub_public" {
  type = string
  default = "subnet-06255d677b4e7f19d"
}

variable "vpc_id" {
  type = string
  default = "vpc-08b216a3673dfc270"
}

source "amazon-ebs" "ubuntu" {
  profile = "Gabriel"
  ami_name      = "ami-teste-aws-acess-keys"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0c02fb55956c7d316"
  ssh_username = "ec2-user"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  vpc_id = "${var.vpc_id}"
  subnet_id = "${var.sub_public}"
}

build {
  name    = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source = "../packer"
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = []
    inline = [
      "cd /tmp/packer",
      "chmod 755 build.sh",
      "./build.sh",
    ]
  }
}
