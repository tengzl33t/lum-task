terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.47.0"
    }
  }
}

provider "aws" {
  assume_role {
    role_arn = "arn:aws:iam::285051607148:role/tofu-deploy"
  }
}
