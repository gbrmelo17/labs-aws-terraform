packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

/*variable "aws_access_key" {
  type = string
  default = "AKIA6EK34VJLVWZMPK7Q"
}

variable "aws_secret_key" {
  type = string
  default = "Sr5trY82ZgUG59YlQ3bmN3CVKyHOcAXPSBQwdMeM"
}
*/

variable "sub_public" {
  type = string
  default = "subnet-034bf96d24b36e74d"
}

variable "vpc_id" {
  type = string
  default = "vpc-094fc63a883627264"
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "ami-dns-php"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami    = "ami-0c02fb55956c7d316"
  ssh_username = "ec2-user"
  vpc_id = "${var.vpc_id}"
  subnet_id = "${var.sub_public}"
  //access_key = "${var.aws_access_key}"
  //secret_key = "${var.aws_secret_key}"
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