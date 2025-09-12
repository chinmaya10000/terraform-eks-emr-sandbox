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

### 1. **Initialize Terraform**

```bash
terraform init
terraform plan
terraform apply --auto-approve
```

---

## Post-Deployment Configuration

### 1. **Configure kubectl**

After Terraform completes, update your kubeconfig:

```bash
aws eks update-kubeconfig --name <cluster_name> --region <aws_region>
```

Check your EKS nodes:

```bash
kubectl get nodes
```

---

## EMR-on-EKS Details

- **Namespace:** `emr`
- **Service Account:** `emr-sa`
- **Virtual Cluster ID:** See Terraform output `emr_virtual_cluster_id`
- **S3 Bucket:** See Terraform output `emr_s3_bucket`
- **IAM Role for EMR Jobs:** See Terraform output `emr_job_role`

---

## Testing EMR-on-EKS (Optional)

Once the EMR setup is ready, you can verify it by running a sample Spark job.

### Example: Run Spark Pi

```bash
aws emr-containers start-job-run \
  --virtual-cluster-id <emr_virtual_cluster_id> \
  --name spark-pi-test \
  --execution-role-arn <execution-role-arn> \
  --release-label emr-6.15.0-latest \
  --job-driver '{
    "sparkSubmitJobDriver": {
      "entryPoint": "local:///usr/lib/spark/examples/src/main/python/pi.py",
      "sparkSubmitParameters": "--conf spark.executor.instances=2 --conf spark.executor.memory=2G --conf spark.driver.memory=1G"
    }
  }' \
  --configuration-overrides '{
    "monitoringConfiguration": {
      "s3MonitoringConfiguration": {
        "logUri": "s3://<your-emr-s3-bucket>/logs/"
      }
    }
  }' \
  --region <aws_region>
```

**Replace**:
- `<emr_virtual_cluster_id>` with your Terraform output for EMR virtual cluster ID
- `<execution-role-arn>` with your EMR job role ARN output from Terraform
- `<your-emr-s3-bucket>` with your EMR S3 bucket output from Terraform
- `<aws_region>` with your AWS region

#### Check Job Status

```bash
aws emr-containers describe-job-run \
  --id <job-run-id> \
  --virtual-cluster-id <emr_virtual_cluster_id> \
  --region <aws_region>
```

---

## Terraform Outputs

After deployment, Terraform provides the following outputs:

- **VPC ID:** `vpc_id`
- **Private Subnets:** `private_subnets`
- **Public Subnets:** `public_subnets`
- **EKS Cluster Name:** `cluster_name`
- **EKS Cluster Endpoint:** `cluster_endpoint`
- **EMR Namespace:** `emr_namespace`
- **EMR Service Account:** `emr_service_account`
- **EMR S3 Bucket:** `emr_s3_bucket`
- **EMR Virtual Cluster ID:** `emr_virtual_cluster_id`
- **EMR Virtual Cluster Name:** `emr_virtual_cluster_name`

---

## Cleanup

To remove all resources:

```bash
terraform destroy --auto-approve
```

---

## Troubleshooting & Tips

- Ensure your AWS CLI uses the correct profile and region.
- If IAM errors occur, review and update your user policies.
- Debug failed Spark jobs by checking job status and logs in the EMR console or via AWS CLI.
- For networking issues, verify VPC subnets and security groups.

---

## References

- [Amazon EMR on EKS Documentation](https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/emr-eks.html)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [EKS User Guide](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
