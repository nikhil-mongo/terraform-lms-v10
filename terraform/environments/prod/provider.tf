terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "terraform-lms-v10" # ← your bucket name
    key            = "atlas/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
provider "mongodbatlas" {
  public_key  = jsondecode(data.aws_secretsmanager_secret_version.my_secret_version.secret_string)["public_key"]
  private_key = jsondecode(data.aws_secretsmanager_secret_version.my_secret_version.secret_string)["private_key"]
}
provider "aws" {
  region = "us-east-1"
}
