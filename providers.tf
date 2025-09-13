# Sets the AWS region for all resources
provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  
  # Backend: S3 bucket for storing Terraform state securely
  backend "s3" {
    bucket = "terraform-state-emr-2025"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.9.0, < 7.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.35.0, < 3.0.0"
    }
  }
}