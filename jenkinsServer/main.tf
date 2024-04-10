#VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "kenkins-vpc"
  cidr = var.vpc_cidr

  azs            = data.aws_availability_zones.available.names
  public_subnets = var.public_subnets

  enable_dns_hostnames = true

  tags = {
    Name        = "jenkins-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}

#SG
module "sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "jekins-sg"
  description = "sg for jenkins"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "all"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Name        = "jenkins-sg"
    Terraform   = "true"
    Environment = "dev"
  }
}

#EC2
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "jekins-server"

  instance_type               = var.instance_type
  key_name                    = "jenkins-server-key"
  monitoring                  = true
  vpc_security_group_ids      = [module.sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  user_data                   = file("jenkins-install.sh")
  availability_zone           = data.aws_availability_zones.available.names[0]



  tags = {
    Name        = "jenkins-server"
    Terraform   = "true"
    Environment = "dev"
  }
}