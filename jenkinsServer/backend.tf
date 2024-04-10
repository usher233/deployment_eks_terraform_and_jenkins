terraform {
  backend "s3" {
    bucket = "viktor-bucket-010622"
    key    = "jenkins/terraform.tfstate"
    region = "eu-west-3"
  }
}