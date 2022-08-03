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
  default = "subnet-02410c25cb83f0606"
}

variable "vpc_id" {
  type    = string
  default = "vpc-0e0163b4779465e53"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ami-docker2"
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