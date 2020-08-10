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

resource "random_string" "storageaccountname" {
  length  = 13
  upper   = false
  lower   = true
  special = false
}

resource "random_string" "blobcontainername" {
  length  = 13
  upper   = false
  lower   = true
  special = false
}


locals {
  managed_resource_group_name = var.managed_resource_group_name == null ? "mrg-hcs-production-${random_string.number.result}" : var.managed_resource_group_name
}

data "azurerm_client_config" "current" {
}

resource "azurerm_marketplace_agreement" "hcs" {
  count     = var.accept_marketplace_aggrement ? 1 : 0
  publisher = "hashicorp-4665790"
  offer     = "hcs-production"
  plan      = "on-demand"
}

resource "azurerm_managed_application" "hcs" {
  depends_on = [azurerm_marketplace_agreement.hcs]

  name                        = var.application_name
  location                    = var.region
  resource_group_name         = var.resource_group_name
  kind                        = "MarketPlace"
  managed_resource_group_name = local.managed_resource_group_name

  plan {
    name      = "on-demand"
    product   = "hcs-production"
    publisher = "hashicorp-4665790"
    version   = var.hcs_marketplace_version
  }

  parameters = {
    initialConsulVersion  = var.consul_version
    storageAccountName    = random_string.storageaccountname.result
    blobContainerName     = random_string.blobcontainername.result
    clusterMode           = var.consul_cluster_mode
    clusterName           = var.consul_cluster_name
    consulDataCenter      = var.consul_datacenter_name
    numServers            = "3"
    numServersDevelopment = "1"
    automaticUpgrades     = "disabled"
    consulConnect         = "enabled"
    externalEndpoint      = var.external_endpoint ? "enabled" : "disabled"
    snapshotInterval      = "1d"
    snapshotRetention     = "1m"
    consulVnetCidr        = "${var.vnet_starting_ip_address}/24"
    location              = var.region
    providerBaseURL       = var.hcs_base_url
    email                 = var.email
  }
}

data "azurerm_virtual_network" "hcs" {
  depends_on          = [azurerm_managed_application.hcs]
  name                = "hvn-consul-ama-${var.consul_cluster_name}-vnet"
  resource_group_name = local.managed_resource_group_name
}
