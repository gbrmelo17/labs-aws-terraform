packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "sub_public" {
  type = string
  default = "subnet-0f62cc2e39284dbf7"
}

variable "vpc_id" {
  type = string
  default = "vpc-05f30989a71b82bc9"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ami-php-index-loudbalancer"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0c02fb55956c7d316"
  ssh_username = "ec2-user"
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