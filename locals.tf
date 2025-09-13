locals {
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]   # Availability Zones (adjust based on region)
  
  # Private and Public subnet CIDRs
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidr_blocks = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  # Tagging for route tables, NACLs, security groups
  public_route_table_tags     = { Name = "${var.name}-${var.env}-public-rt" }
  private_route_table_tags    = { Name = "${var.name}-${var.env}-private-rt" }
  default_route_table_tags    = { Name = "${var.name}-${var.env}-default-rt" }
  default_network_acl_tags    = { Name = "${var.name}-${var.env}-default-nacl" }
  default_security_group_tags = { Name = "${var.name}-${var.env}-default-sg" }

  # Subnet tags for Kubernetes integration
  public_subnet_tags = {
    Name                                           = "${var.name}-${var.env}-public-subnet"
    Type                                           = "public"
    "kubernetes.io/role/elb"                       = "1"
    "kubernetes.io/cluster/${var.name}-${var.env}" = "shared"
  }

  private_subnet_tags = {
    Name                                             = "${var.name}-${var.env}-private-subnet"
    Type                                             = "private"
    "kubernetes.io/role/internal-elb"                = "1"
    "kubernetes.io/cluster/${var.name}-${var.env}"   = "shared"
  }

  environment_tags = {
    Project     = var.name
    Environment = var.env
  }
}