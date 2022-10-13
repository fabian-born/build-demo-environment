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

variable "automatic_backup_retention" {
  description = "Automatic backup retention for filesystem in days"
  type        = number
}

variable "fsxadmin_password" {
  description = "ONTAP administrative password fsxadmin user"
  type        = string
  sensitive   = true
}

variable "svm_name" {
  description = "Name of svm"
  type        = string
}

variable "netbios_name" {
  description = "Name of cifs machine account"
  type        = string
}


variable "dns_ips" {
  description = "Array of IPs for nameservers"
  type        = list(string)
}

variable "domain_name" {
  description = "Name of cifs domain to join"
  type        = string
  default = "addomain"
}

variable "ad_username" {
  description = "Active Directory administrator username"
  type        = string
  sensitive   = true
  default ="admin"
}

variable "ad_password" {
  description = "Active Directory administrator password"
  type        = string
  sensitive   = true
  default = "userpassword"
}

