terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Estado remoto no S3 — crie o bucket antes: aws s3 mb s3://oficina-terraform-state-<seu-sufixo>
  backend "s3" {
    bucket = "oficina-terraform-state"
    key    = "database/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "oficina"
      Phase     = "fase-3"
      ManagedBy = "terraform"
      Repo      = "oficina-infra-database"
    }
  }
}
