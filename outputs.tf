output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}


# Cluster Info
output "cluster_name" {
  description = "The name of the EKS cluster"
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value = module.eks.cluster_endpoint
}

output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value = "aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.aws_region}"
}


output "emr_namespace" {
  description = "Kubernetes namespace for EMR jobs"
  value       = kubernetes_namespace.emr.metadata[0].name
}

output "emr_service_account" {
  description = "Service account used by EMR jobs"
  value       = kubernetes_service_account.emr.metadata[0].name
}

output "emr_s3_bucket" {
  description = "S3 bucket for EMR job input/output"
  value       = aws_s3_bucket.emr_results.bucket
}

output "emr_virtual_cluster_id" {
  description = "The ID of the EMR-on-EKS virtual cluster"
  value       = aws_emrcontainers_virtual_cluster.emr.id
}

output "emr_virtual_cluster_name" {
  description = "The name of the EMR-on-EKS virtual cluster"
  value       = aws_emrcontainers_virtual_cluster.emr.name
}