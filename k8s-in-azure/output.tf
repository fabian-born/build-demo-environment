/*
 output "client_certificate" {
  value = azurerm_kubernetes_cluster.akscluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.akscluster.kube_config_raw
} 

output "clusterinfo" {
  value = azurerm_kubernetes_cluster.akscluster.node_resource_group
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.vnet_nodepool.name
}

output "nodepool_infos" {
  value = data.azurerm_resources.rg_nodepool.resources.0.name
}

output "clustername" {
  value = "${data.azurerm_resource_group.default.name}"
}
*/ 

