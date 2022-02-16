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
  region = "ap-southeast-1"
  shared_credentials_file = "/home/maya/.aws/credentials"
  profile = "softopark"
}

# Configure ec2 instance type
# Configure EBS storage & install docker and nginx
# Add Your pem file on the key_name
resource "aws_instance" "terraform" {
  ami           = "ami-055d15d9cfddf7bd3"
  key_name        = "dockertest"
  security_groups = [data.aws_security_group.web-access.name]
  instance_type = "t2.micro"

  ebs_block_device {
    device_name = "/dev/sda1"
    # encrypted = true
    # kms_key_id = "5e8d7b1b-aef2-4808-aeaa-123f1f921376"
    volume_size = 10
    volume_type = "gp2"
  }  
  tags = {
      Name = "built-with-terraform"
  }
  user_data = <<-EOF
              #!/bin/bash
              echo 'echo "##########################"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#                        #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#  Built with Terraform  #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#                        #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "#                        #"'   >>  /home/ubuntu/.bashrc
              echo 'echo "##########################"'   >>  /home/ubuntu/.bashrc
              sudo apt update -y && sudo apt upgrade -y
              #######################"Installing Docker & compose"###########################
              curl -fsSL https://get.docker.com -o get-docker.sh
              sh get-docker.sh
              sudo usermod -aG docker ubuntu
              sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              #######################"Installing certbot"####################################
              yes '' | sudo add-apt-repository ppa:certbot/certbot
              sudo apt install python3-certbot-nginx -y
              #######################"Installing nginx and breaking it"############
              sudo apt install nginx -y
              sudo chown ubuntu:ubuntu /usr/share/nginx/html/ -R
              sudo chown ubuntu:ubuntu /var/www/html -R
              sudo bash -c 'echo "Hello!" > /var/www/html/index.html'
             EOF
}

# configure security group firewall
# data "aws_security_group" "web-access" {
#   id = "sg-c4963aa1"
# }

data "aws_security_group" "web-access" {
  id = "sg-1f6feb68"
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