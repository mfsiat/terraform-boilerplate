terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-southeast-1"
  shared_credentials_file = "/home/maya/.aws/credentials"
  profile = "softopark"
}

resource "aws_instance" "terraform" {
  ami           = "ami-055d15d9cfddf7bd3"
  key_name        = "dockertest"
  security_groups = [data.aws_security_group.Test-cicd.name]
  instance_type = "t2.micro"
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

data "aws_security_group" "Test-cicd" {
  id = "sg-08f97cdd365414625"
}

# resource "aws_ebs_volume" "terraform" {
#   availability_zone = "ap-southeast-1"
#   size              = 40

#   tags = {
#     Name = "terraform-test"
#   }
# }

output "IP" {
  value = aws_instance.terraform.public_ip
}