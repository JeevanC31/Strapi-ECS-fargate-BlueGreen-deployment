terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket = "strapi-terraform-state-jeevan"
    key    = "task-10/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}