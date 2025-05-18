terraform {
  backend "s3" {
    bucket         = "eks-s3-be"
    region         = "ap-south-1"
    key            = "End-to-End-Kubernetes-DevSecOps-Tetris-Project/Jenkins-Server-TF/terraform.tfstate"
    #dynamodb_table = "devsecops-demo"
    encrypt        = true
    use_lockfile = true
  }
  required_version = ">=1.10"
  required_providers {
    aws = {
      version = ">= 5.0"
      source  = "hashicorp/aws"
    }
  }
}