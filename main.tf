resource "azurerm_marketplace_agreement" "hcs" {
  publisher = "hashicorp-4665790"
  offer     = "hcs-production"
  plan      = "public-beta"
}

resource "azurerm_resource_group" "hcs" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_template_deployment" "hcs" {
  depends_on = [azurerm_marketplace_agreement.hcs]
  name                = var.deployment_name
  resource_group_name = azurerm_resource_group.hcs.name
  template_body = file("template.json")


 parameters = {
    initialConsulVersion  = "v1.7.2"
    clusterName       = azurerm_resource_group.hcs.name
    consulDataCenter    = "dc1"
    clusterMode = "PRODUCTION"
    automaticUpgrades = "disabled"
    externalEndpoint = "disabled"
    externalEndpoint   = "enabled"
    consulVnetCidr = "10.11.12.0/24"
    location = var.location
    applicationResourceName = azurerm_resource_group.hcs.name
    managedResourceGroupId = null
  }

  deployment_mode = "Incremental"
}
