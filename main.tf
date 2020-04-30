terraform {
  required_version = ">= 0.12.24"
  # experiments      = [variable_validation]
  required_providers {
    azurerm = ">= 2.7.0"
    random  = ">= 2.2.1"
  }
}

resource "random_string" "number" {
  length  = 14
  upper   = false
  lower   = false
  special = false
}

data "azurerm_client_config" "current" {
}

resource "azurerm_marketplace_agreement" "hcs" {
  count     = var.accept_marketplace_aggrement ? 1 : 0
  publisher = "hashicorp-4665790"
  offer     = "hcs-production"
  plan      = "public-beta"
}

resource "azurerm_resource_group" "hcs" {
  name     = var.resource_group_name
  location = var.region
}

resource "azurerm_template_deployment" "hcs" {
  depends_on = [azurerm_marketplace_agreement.hcs]

  # name                = "hashicorp-4665790.hcs-production-${formatdate("YYYYMMDDhhmmss", timestamp())}"
  name                = "hashicorp-4665790.hcs-production-${random_string.number.result}"
  resource_group_name = azurerm_resource_group.hcs.name

  parameters = {
    initialConsulVersion    = var.consul_version
    clusterName             = var.consul_cluster_name
    consulDataCenter        = var.consul_datacenter_name
    clusterMode             = var.consul_cluster_mode
    externalEndpoint        = var.external_endpoint ? "enabled" : "disabled"
    consulVnetCidr          = "${var.vnet_starting_ip_address}/24"
    location                = var.region
    applicationResourceName = var.application_name
    # managedResourceGroupId  = var.managed_resource_group_name == null ? "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/mrg-hcs-production-${formatdate("YYYYMMDDhhmmss", timestamp())}" : var.managed_resource_group_name
    managedResourceGroupId = var.managed_resource_group_name == null ? "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/mrg-hcs-production-${random_string.number.result}" : var.managed_resource_group_name
  }

  template_body   = file("${path.module}/files/template.json")
  deployment_mode = "Incremental"
}
