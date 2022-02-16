# Terraform boilerplate

- First configure awscli 
- Configure aws cli with **`profile name`**
- Add the profile on **`main.tf`**
- Change the profile name for aws access keys 
```
provider "aws" {
  region = "your_region_name"
  shared_credentials_file = "/home/maya/.aws/credentials"
  profile = "your_profile_name"
}
```

## To run Terraform 

- First install terraform from this [link](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Clone the repo 
- INIT Terraform by typing: **`terraform init`**
- Configure **`main.tf`**
- Then validate configuration by typing: **`terraform validate`**
- View the configuration for your ec2 type: **`terraform plan`**
- Create **EC2** by: **`terraform apply`**
- View the created **EC2** by: **`terraform view`**
- Destroy the created resources by terraform by: **`terraform destroy`**
