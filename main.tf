terraform {
  required_version = ">= 0.12.24"
  # experiments      = [variable_validation]
  required_providers {
    azurerm = ">= 2.8.0"
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

resource "azurerm_managed_application" "hcs" {
  depends_on = [azurerm_marketplace_agreement.hcs]

  name                        = var.application_name
  location                    = var.region
  resource_group_name         = var.resource_group_name
  kind                        = "MarketPlace"
  managed_resource_group_name = var.managed_resource_group_name == null ? "mrg-hcs-production-${random_string.number.result}" : var.managed_resource_group_name

  plan {
    name      = "public-beta"
    product   = "hcs-production"
    publisher = "hashicorp-4665790"
    version   = "0.0.28"
  }

  parameters = {
    "initialConsulVersion" = var.consul_version
    "clusterMode"          = var.consul_cluster_mode
    "clusterName"          = var.consul_cluster_name
    "consulDataCenter"     = var.consul_datacenter_name
    "numServers"           = var.number_of_servers
    "externalEndpoint"     = var.external_endpoint ? "enabled" : "disabled"
    "consulVnetCidr"       = "${var.vnet_starting_ip_address}/24"
    "location"             = var.region
  }
}
