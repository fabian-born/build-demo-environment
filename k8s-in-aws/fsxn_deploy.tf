terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }

  #required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_fsx_ontap_file_system" "fsxn" {
  storage_capacity                = var.fs_capacity
  subnet_ids                      = var.subnet_ids
  deployment_type                 = var.deployment_type
  throughput_capacity             = var.fs_throughput
  preferred_subnet_id             = var.subnet_ids[0]
  automatic_backup_retention_days = var.automatic_backup_retention
  fsx_admin_password              = var.fsxadmin_password
  tags = {
    Name      = "fabianb_demo"
    Terraform = "True"
    Owner     = "fabianb"
  }

}

resource "aws_fsx_ontap_storage_virtual_machine" "svm_demo" {
  file_system_id = aws_fsx_ontap_file_system.fsxn.id
  name           = var.svm_name

}

