provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "hcs" {
  name     = "hcs-example"
  location = "West Europe"
}

module "hcs" {
  source              = "cpu601/hcs/azurerm"
  resource_group_name = azurerm_resource_group.hcs.hcs.name
  application_name    = "hcs"
  consul_cluster_name = "example-consul-cluster"
  external_endpoint   = true
}

output "consul_url" {
  value = module.hcs.consul_url
}
