module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Makes the cluster's Kubernetes API reachable publicly (simplest for learning).
  # In production, you'd typically set this to false and rely on a VPN/bastion.
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Lets the IAM identity that runs `terraform apply` automatically become
  # a Kubernetes admin (cluster-admin) on the cluster.
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      instance_types = [var.node_instance_type]

      min_size     = var.min_capacity
      max_size     = var.max_capacity
      desired_size = var.desired_capacity

      capacity_type = "ON_DEMAND" # or "SPOT" for cheaper, interruptible nodes
    }
  }

  tags = {
    Project = var.cluster_name
  }
}