resource "random_pet" "prefix" {}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  /*tenant_id       = var.az_tenantId */
  skip_provider_registration = "true"
  /* version = "2.99.0" */
}

data "azurerm_resource_group" "default" {
  name     = var.az_existingRG
}



/* Download Kubeconfig */
resource "local_file" "kubeconfig" {
  content  = "${azurerm_kubernetes_cluster.akscluster.kube_config_raw}"
  filename = "../delivery/kubeconfig-azure-${random_pet.prefix.id}"
}

