
data "azurerm_netapp_account" "aks" {
  resource_group_name = var.az_existingRG
  name                = var.az_anfaccount
}


resource "azurerm_netapp_pool" "aks" {
  name                = var.az_anf_poolname
  account_name        = data.azurerm_netapp_account.aks.name
  location            = var.az_location
  resource_group_name = var.az_existingRG
  service_level       = var.az_anf_sl
  size_in_tb          = var.az_anf_poolsize
}



