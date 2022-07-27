packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "sub_public" {
  type    = string
  default = "subnet-035914b8bebaf8202"
}

variable "vpc_id" {
  type    = string
  default = "vpc-08df2ceaf571c0827"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ami-docker"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0cff7528ff583bf9a"
  ssh_username  = "ec2-user"
  vpc_id        = "${var.vpc_id}"
  subnet_id     = "${var.sub_public}"

}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
    source      = "../packer"
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