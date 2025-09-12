variable "name" {
  description = "Project name"
  type        = string
  default     = "eks-emr"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "env" {
  description = "The environment for the deployment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "single_nat_gateway" {
  description = "Use single NAT gateway instead of one per AZ"
  type        = bool
  default     = true
}

variable "k8s_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.33"
}