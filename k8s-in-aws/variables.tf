variable "aws_region" {
  description = "Region in AWS"
  type        = string
  default     = "eu-central-1"
}

variable "eks_clustername" {
  description = "EKS Cluster Name"
  type        = string
  default     = "ekscluster"
}

variable "subnet_ids" {
  description = "Array of subnet ids"
  type        = list(string)
}

variable "prefix" {}

variable "deployment_type" {}

variable "fs_capacity" {}

variable "fs_throughput" {}
 
variable "automatic_backup_retention" {}

variable "spotinst_token" {}

variable "spotinst_account" {}