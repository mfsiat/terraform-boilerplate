terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
# Add aws profile name
provider "aws" {
  region                  = "ap-southeast-1"
  shared_credentials_file = "/home/maya/.aws/credentials"
  profile                 = "softopark"
}

# Configure ec2 instance type
# Configure EBS storage & install docker and nginx
# Add Your pem file on the key_name
resource "aws_instance" "terraform" {
  # ami           = "ami-055d15d9cfddf7bd3"
  # ubuntu 20
  ami           = "ami-08be951cec06726be"
  # ubuntu 22
  # ami             = "ami-029562ad87fe1185c"
  key_name        = "jo-hukum-app"
  security_groups = [data.aws_security_group.web-access.name]
  instance_type = "t2.micro"
  # instance_type = "t3.small"

  ebs_block_device {
    device_name = "/dev/sda1"
    # encrypted = true
    # kms_key_id = "5e8d7b1b-aef2-4808-aeaa-123f1f921376"
    volume_size = 50
    volume_type = "gp2"
  }
  tags = {
    Name = "logstash"
  }
  user_data = <<-EOF
              #!/bin/bash
              echo 'echo "##########################"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#                        #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#  Built with Terraform  #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#       Logstash         #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#                        #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#                        #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "##########################"'   >>  /home/ubuntu/.bashrc
              echo 'export HISTTIMEFORMAT="%F %T "'      >>  /home/ubuntu/.bashrc
              source .bashrc
              sudo apt update -y && sudo apt upgrade -y
              #######################"Installing Docker & compose"###########################
              curl -fsSL https://get.docker.com -o get-docker.sh
              sh get-docker.sh
              sudo usermod -aG docker ubuntu
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              sudo hostnamectl set-hostname logstash
             EOF
}

# configure security group firewall
# data "aws_security_group" "web-access" {
#   id = "sg-c4963aa1"
# }

data "aws_security_group" "web-access" {
  id = "sg-1f6feb68"
  # id = "sg-079f88bdbd343c3c4"
}

# Configure DNS add your dns if you have anything on Route53
# Route 53 
# Setup dns
# data "aws_route53_zone" "main" {
#   name = "iqraservices.com"
# }


# resource "aws_route53_record" "deploy" {
#   zone_id = data.aws_route53_zone.main.zone_id 
#   name    = "traefik-dashboard.iqraservices.com"
#   type    = "A"
#   ttl     = "60"
#   # records = ["10.0.0.1"]
#   records = [aws_instance.terraform.public_ip]
# }
output "IP" {
  value = aws_instance.terraform.public_ip
}

output "id" {
  value = aws_instance.terraform.id
}
