vpc_cidr       = "192.168.0.0/16"
public_subnets = ["192.168.4.0/24","192.168.5.0/24","192.168.6.0/24"]
private_subnets = ["192.168.1.0/24","192.168.2.0/24","192.168.3.0/24"]
cluster_name = "my-eks-cluster"
instance_type = ["t2.small"]