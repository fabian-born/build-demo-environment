terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.31.0"
    }
    spotinst = {
      source = "spotinst/spotinst"
      version = "1.84.0"
    }
  }
}




provider "aws" {
  # Configuration options
  region     = var.aws_region
  access_key = ""
  secret_key = ""
}

resource "random_pet" "prefix" {
  length = 2
}
