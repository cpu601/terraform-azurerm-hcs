output "get_hcs_config_command" {
  value       = <<EOF
  az resource show \
  --ids "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.hcs.name}/providers/Microsoft.Solutions/applications/${var.application_name}/customconsulClusters/${var.consul_cluster_name}" \
  --api-version 2018-09-01-preview
  EOF
  description = "Azure CLI command to get HCS configuration which includes Consul API URL, Consul CA file, Consul config file and more."
}
