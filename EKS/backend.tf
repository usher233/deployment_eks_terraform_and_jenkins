terraform {
  backend "s3" {
    bucket = "viktor-bucket-010622"
    key = "eks/terraform.tfstate"
    region = "eu-west-3"
  }
  
}
