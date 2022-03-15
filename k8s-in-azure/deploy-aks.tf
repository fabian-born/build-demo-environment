
###
/*
resource "azurerm_virtual_network" "astra-vnet" {
  name                = "${var.prefix}-astra-vnet"
  resource_group_name = "${data.azurerm_resource_group.default.name}"
  location            = "germanywestcentral"
  address_space       = ["10.2.0.0/16"]
}
resource "azurerm_subnet" "FrontEnd" {
  name                 = "FrontEnd"
  resource_group_name = "${data.azurerm_resource_group.default.name}"
  virtual_network_name = "${azurerm_virtual_network.astra-vnet.name}"
  address_prefix       = "10.2.0.0/24"
}
resource "azurerm_subnet" "BackEnd" {
  name                 = "BackEnd"
  resource_group_name = "${data.azurerm_resource_group.default.name}"
  virtual_network_name = "${azurerm_virtual_network.astra-vnet.name}"
  address_prefix      = "10.2.1.0/24"
  delegation {
    name = "netapp"

    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}
*/

resource "azurerm_kubernetes_cluster" "akscluster" {
  name                = "${var.prefix}-${random_pet.prefix.id}"
  location            = var.az_location
  resource_group_name = data.azurerm_resource_group.default.name
  dns_prefix          = "${random_pet.prefix.id}-pub"

  default_node_pool {
    name       = "default"
    node_count = "${var.aks_node_number}"
    vm_size    = "Standard_D2_v2"
    
//    availability_zones   = [1, 2, 3]
//    enable_auto_scaling  = true
//    max_count            = 3
//    min_count            = 1
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}

data "azurerm_resources" "rg_nodepool" {
  resource_group_name = azurerm_kubernetes_cluster.akscluster.node_resource_group
  type = "Microsoft.Network/virtualNetworks"
}


data "azurerm_virtual_network" "vnet_nodepool" {
  name                = data.azurerm_resources.rg_nodepool.resources.0.name
  resource_group_name = azurerm_kubernetes_cluster.akscluster.node_resource_group
}

resource "azurerm_subnet" "anfsubnet" {
  name                 = "anf-subnet-${random_pet.prefix.id}"
  resource_group_name = azurerm_kubernetes_cluster.akscluster.node_resource_group
  virtual_network_name = data.azurerm_virtual_network.vnet_nodepool.name
  address_prefixes      = ["10.225.0.0/24"]
  delegation {
    name = "netapp"

    service_delegation {
      name    = "Microsoft.Netapp/volumes"
      actions = ["Microsoft.Network/networkinterfaces/*", "Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}


resource "null_resource" "kubectl" {
  provisioner "local-exec" {
    command = "kubectl ${var.cmd_snapshotter} --kubeconfig <(echo $KUBECONFIG | base64 --decode)"
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = base64encode(azurerm_kubernetes_cluster.akscluster.kube_config_raw)
    }
  }
}
