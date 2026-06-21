# AWS EKS Cluster with Terraform

This project provisions a complete, production-style Amazon EKS (Elastic Kubernetes Service) cluster using Terraform — including networking (VPC), IAM roles, the EKS control plane, and a managed worker node group.

## Architecture

- Custom VPC with 3 public subnets and 3 private subnets across multiple Availability Zones
- NAT Gateway for outbound internet access from private subnets
- EKS control plane (managed by AWS)
- EKS Managed Node Group running worker nodes in private subnets
- IAM roles for the cluster and nodes, created automatically by the Terraform modules

## Project Structure

```
eks-terraform/
├── provider.tf               # Terraform + AWS provider configuration
├── variables.tf               # Input variable definitions
├── terraform.tfvars.example   # Example values (copy to terraform.tfvars)
├── vpc.tf                     # VPC, subnets, NAT gateway
├── eks.tf                     # EKS cluster + managed node group
├── outputs.tf                 # Useful outputs after apply
├── k8s/
│   └── deployment.yaml        # Sample app to test the cluster
└── README.md
```

## Prerequisites

- AWS account with sufficient IAM permissions
- [AWS CLI](https://aws.amazon.com/cli/) configured (`aws configure`)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Usage

1. Clone the repo:
   ```bash
   git clone https://github.com/vaibhavs164/terraform-eks-project.git
   cd terraform-eks-project
   ```

2. Copy the example variables file and edit as needed:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the execution plan:
   ```bash
   terraform plan
   ```

5. Apply:
   ```bash
   terraform apply
   ```

6. Connect kubectl to the new cluster:
   ```bash
   aws eks update-kubeconfig --region ap-south-1 --name demo-eks-cluster
   kubectl get nodes
   ```

7. Deploy the sample app:
   ```bash
   kubectl apply -f k8s/deployment.yaml
   kubectl get svc nginx-demo-svc
   ```

## Cleanup

Always destroy resources when done to avoid ongoing AWS charges:

```bash
kubectl delete -f k8s/deployment.yaml
terraform destroy
```

## Notes

- Check [AWS's supported EKS Kubernetes versions](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions-standard.html) before setting `cluster_version` — AWS only supports each version for a limited window.
- `terraform.tfvars` and `terraform.tfstate*` are gitignored — never commit real values or state files, since they can contain sensitive information.
