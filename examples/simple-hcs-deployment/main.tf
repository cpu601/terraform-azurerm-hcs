provider "azurerm" {
  features {}
}

module "hcs" {
  source              = "cpu601/hcs/azurerm"
  resource_group_name = "my-rg-for-consul"
  application_name    = "hcs"
  consul_cluster_name = "my-consul-cluster"
  external_endpoint   = true
}

output "hcs_config_command" {
  value = module.hcs.get_hcs_config_command
}
