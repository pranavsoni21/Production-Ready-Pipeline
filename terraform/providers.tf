# Defining module to use for provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Setting up provider
provider "aws" {
  region = "ap-south-1"
}