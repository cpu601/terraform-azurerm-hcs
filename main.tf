terraform {
  required_version = ">= 0.12.24"
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

resource "azurerm_resource_group" "hcs" {
  name     = var.resource_group_name
  location = var.region
}

resource "azurerm_managed_application" "hcs" {
  name                        = var.application_name
  location                    = var.region
  resource_group_name         = azurerm_resource_group.hcs.name
  kind                        = "MarketPlace"
  managed_resource_group_name = var.managed_resource_group_name == null ? "mrg-hcs-production-${random_string.number.result}" : var.managed_resource_group_name

  plan {
    name      = "public-beta"
    product   = "hcs-production"
    publisher = "hashicorp-4665790"
    version   = "0.0.28"
  }

  parameters = {
    initialConsulVersion    = var.consul_version
    clusterName             = var.consul_cluster_name
    consulDataCenter        = var.consul_datacenter_name
    clusterMode             = var.consul_cluster_mode
    externalEndpoint        = var.external_endpoint ? "enabled" : "disabled"
    consulVnetCidr          = "${var.vnet_starting_ip_address}/24"
    location                = var.region
  }
}