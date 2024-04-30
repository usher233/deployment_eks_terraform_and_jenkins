#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.available.names

  private_subnets = var.private_subnets
  public_subnets = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true



  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# EKS
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  cluster_version = "1.29"
  cluster_name = var.cluster_name

  cluster_endpoint_public_access = true

  
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      min_size = 1
      max_size = 3
      desired_size = 2

      instance_type = var.instance_type
    }
  }

  tags ={
    Environment = "dev"
    Terraform = "true"
  }
}