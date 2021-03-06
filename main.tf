terraform {
  required_version = ">= 0.12.24"
  required_providers {
    azurerm = ">= 2.8.0"
    random  = ">= 2.2.1"
    http    = ">= 2.0.0"
  }
}

data "http" "cloud_hcs_meta" {
  url = "https://raw.githubusercontent.com/hashicorp/cloud-hcs-meta/master/ama-plans/defaults.json"
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
  plan      = lookup(jsondecode(data.http.cloud_hcs_meta.body), "name")
}

resource "azurerm_managed_application" "hcs" {
  depends_on = [azurerm_marketplace_agreement.hcs]

  name                        = var.application_name
  location                    = var.region
  resource_group_name         = var.resource_group_name
  kind                        = "MarketPlace"
  managed_resource_group_name = local.managed_resource_group_name

  lifecycle {
    ignore_changes = [
      plan,
      parameters
    ]
  }

  plan {
    name      = lookup(jsondecode(data.http.cloud_hcs_meta.body), "name")
    product   = "hcs-production"
    publisher = "hashicorp-4665790"
    version   = lookup(jsondecode(data.http.cloud_hcs_meta.body), "version")
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
    federationToken       = null
    snapshotInterval      = "1d"
    snapshotRetention     = "1m"
    consulVnetCidr        = "${var.vnet_starting_ip_address}/24"
    location              = var.region
    providerBaseURL       = "https://ama-api.hashicorp.cloud/consulama/${lookup(jsondecode(data.http.cloud_hcs_meta.body), "ama_api_version")}"
    email                 = var.email
  }
}

data "azurerm_virtual_network" "hcs" {
  name                = "${lookup(azurerm_managed_application.hcs.outputs, "vnet_name")}-vnet"
  resource_group_name = local.managed_resource_group_name
}
