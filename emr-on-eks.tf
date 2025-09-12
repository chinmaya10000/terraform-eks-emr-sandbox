provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

# EMR Namespace
resource "kubernetes_namespace" "emr" {
  metadata {
    name = "emr"
  }
}

# IAM Role for EMR jobs (IRSA)
resource "aws_iam_role" "emr_job_role" {
  name = "emr-job-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${module.eks.cluster_oidc_issuer}:sub" = "system:serviceaccount:emr:emr-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "emr_s3_attach" {
  role       = aws_iam_role.emr_job_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# ServiceAccount for EMR jobs
resource "kubernetes_service_account" "emr" {
  metadata {
    name      = "emr-sa"
    namespace = kubernetes_namespace.emr.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.emr_job_role.arn
    }
  }
}

# S3 Bucket for Spark job input/output
resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "emr_results" {
  bucket = "emr-results-${var.env}-${random_id.bucket_id.hex}"
}

resource "aws_s3_bucket_public_access_block" "emr_results" {
  bucket                  = aws_s3_bucket.emr_results.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_emr_virtual_cluster" "emr" {
  name = "emr-virtual-cluster-${var.env}"

  container_provider {
    id   = module.eks.cluster_id
    type = "EKS"
    info {
      eks_info {
        namespace = kubernetes_namespace.emr.metadata[0].name
      }
    }
  }
}