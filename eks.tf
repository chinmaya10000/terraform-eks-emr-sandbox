# -----------------------------
# EKS Cluster (Auto-Mode)
# -----------------------------
# Auto-mode creates a default managed node group
# Nodes are in private subnets

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.name}-${var.env}"
  kubernetes_version = var.k8s_version

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
 
  # Auto-mode: automatically create a default node group
  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets    # Nodes in private subnets

  # KMS encryption for cluster secrets
  create_kms_key                  = true
  kms_key_description             = "KMS key for EKS cluster ${var.name}-${var.env}"
  kms_key_deletion_window_in_days = 7
 

  tags = local.environment_tags
  
  depends_on = [ module.vpc ]
}