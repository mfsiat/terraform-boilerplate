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

  ebs_block_device {
    device_name = "/dev/sda1"
    encrypted = true
    kms_key_id = "5e8d7b1b-aef2-4808-aeaa-123f1f921376"
    volume_size = 20
    volume_type = "gp2"
  }
  
  # root_block_device {
  #   delete_on_termination = true
  #   encrypted = true
  #   kms_key_id = "5e8d7b1b-aef2-4808-aeaa-123f1f921376"
  #   volume_size = 20
  #   volume_type = "gp2"
  # }
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
              #######################"Setup PHP & Composer"############################################
              sudo apt-add-repository ppa:ondrej/php
              sudo apt update -y
              sudo apt install -y php7.1 php7.1-cli php7.1-common php7.1-fpm
              sudo apt install -y php7.1-mysql php7.1-dom php7.1-simplexml php7.1-ssh2 php7.1-xml php7.1-xmlreader php7.1-curl  php7.1-exif  php7.1-ftp php7.1-gd  php7.1-iconv php7.1-imagick php7.1-json  php7.1-mbstring php7.1-posix php7.1-sockets php7.1-tokenizer
              sudo apt install -y php7.1-mysqli php7.1-pdo  php7.1-sqlite3 php7.1-ctype php7.1-fileinfo php7.1-zip php7.1-exif
              cd ~
              curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
              HASH=`curl -sS https://composer.github.io/installer.sig`
              echo $HASH
              php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
              sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
              ###################"Setup Supervisor"#####################################################
              sudo apt install supervisor
             EOF
}

data "aws_security_group" "Test-cicd" {
  id = "sg-08f97cdd365414625"
}
# data "root_block_device" "test" {
#   delete_on_termination = true
#   device_name           = "/dev/sda1"
#   encrypted             = false
#   tags                  = {
#     Name = "terraform"
#   }
#   volume_size           = 16
#   volume_type           = "gp2"
# }

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

output "id" {
  value = aws_instance.terraform.id
}