packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "cloudticket-v2" {
  region = "ap-southeast-2"
  vpc_id    = "vpc-0c22d9f99052647ce"
  subnet_id = "subnet-0863bc92db752c217"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    owners      = ["099720109477"]
    most_recent = true
  }

  instance_type = "t3.micro"

  ssh_username = "ubuntu"

  ami_name = "cloudticket-v2-base-{{timestamp}}"
}

build {
  sources = [
    "source.amazon-ebs.cloudticket-v2"
  ]

  provisioner "shell" {
    script = "scripts/install-docker.sh"
  }
}