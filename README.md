# EKS + EMR-on-EKS Terraform Deployment

This Terraform project provisions a fully functional **EKS cluster** and **EMR-on-EKS virtual cluster** in AWS. It includes:

- VPC with public/private subnets and NAT gateway
- EKS cluster with managed node groups
- EMR namespace and service account
- IAM roles for EMR-on-EKS jobs (IRSA)
- S3 bucket for Spark job input/output
- EMR-on-EKS virtual cluster

This setup is sandbox-ready and allows you to run Spark jobs to validate the EMR configuration.

---

## Project Structure

| File            | Description |
|-----------------|-------------|
| `providers.tf`  | AWS and Kubernetes providers configuration |
| `variables.tf`  | Input variables for the deployment |
| `locals.tf`     | Local values for AZs, subnets, tags |
| `vpc.tf`        | VPC, subnets, NAT, IGW configuration |
| `eks.tf`        | EKS cluster and node groups configuration |
| `emr.tf`        | EMR namespace, IAM roles, virtual cluster, S3 bucket |
| `outputs.tf`    | Terraform outputs for cluster info and EMR resources |

---

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured for the sandbox account
- kubectl installed
- IAM user with permissions to create VPC, EKS, IAM roles, S3, and EMR resources

---

## Deployment Steps

1. **Initialize Terraform**

```bash
terraform init
terraform plan
terraform apply --auto-approve

### Configure kubectl

1. **After Terraform completes, update your kubeconfig:**
```bash
aws eks update-kubeconfig --name <cluster_name> --region <aws_region>

2. **Check the nodes:**
```bash
kubectl get nodes

## EMR-on-EKS Details

- Namespace: emr
- Service Account: emr-sa
- Virtual Cluster ID: See Terraform output emr_virtual_cluster_id
- S3 Bucket: See Terraform output emr_s3_bucket
- IAM Role for EMR Jobs: See Terraform output emr_job_role
