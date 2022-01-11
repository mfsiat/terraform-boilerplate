# Terraform boilerplate

- First configure awscli 
- Change the profile name for aws access keys 
```
provider "aws" {
  region = "your_region_name"
  shared_credentials_file = "/home/maya/.aws/credentials"
  profile = "your_profile_name"
}
```