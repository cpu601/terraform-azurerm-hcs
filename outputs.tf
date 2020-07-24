output "get_hcs_config_command" {
  value       = <<EOF

  az resource show \
  --ids "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Solutions/applications/${var.application_name}/customconsulClusters/${var.consul_cluster_name}" \
  --api-version 2018-09-01-preview
  EOF
  description = "Azure CLI command to get HCS for Azure configuration which includes Consul API URL, Consul CA file, Consul config file and more."
}

output "consul_url" {
  value       = azurerm_managed_application.hcs.outputs["consul_url"]
  description = "URL of the HCS for Azure Consul Cluster API and UI."
}

output "resource_id" {
  value       = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Solutions/applications/${var.application_name}/customconsulClusters/${var.consul_cluster_name}"
  description = "Full id for the Consul cluster resource"
}

output "resource_group_name" {
  value       = azurerm_managed_application.hcs.resource_group_name
  description = "Name of the resource group where HCS on Azure is deployed in."
}

output "managed_resource_group_name" {
  value       = azurerm_managed_application.hcs.managed_resource_group_name
  description = "Name of the managed resource group that will be created by HCS on Azure."
}

output "region" {
  value       = azurerm_managed_application.hcs.managed_resource_group_name
  description = "Region of the managed resource group that will be created by HCS on Azure."
}

output "application_name" {
  value       = azurerm_managed_application.hcs.name
  description = "Name of the managed application that is HCS on Azure."
}

output "subscription_id" {
  value       = data.azurerm_client_config.current.subscription_id
  description = "Id of the subscription HCS on Azure is running in."
}

output "consul_cluster_name" {
  value = var.consul_cluster_name
  description = "Name of the managed Consul cluster."
}

output "managed_vnet_id" {
  value = data.azurerm_virtual_network.hcs.id
  description = "Id of the VNET the managed Consul cluster is connected to."
}

output "managed_vnet_name" {
  value = data.azurerm_virtual_network.hcs.name
    description = "Name of the VNET the managed Consul cluster is connected to."
}

output "managed_vnet_region" {
  value = data.azurerm_virtual_network.hcs.location
  description = "Region of the VNET the managed Consul cluster is connected to."
}

output "managed_vnet_resource_group_name" {
  value = data.azurerm_virtual_network.hcs.resource_group_name
  description = "Name of the resource group of the VNET the managed Consul cluster is connected to. Should be the same as the managed_resource_group_name output."
}

