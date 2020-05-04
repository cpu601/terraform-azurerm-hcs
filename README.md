# terraform-azurerm-hcs

This Terraform module will allow to deploy HashiCorp Consul Service (HCS) on Azure. HCS is currently in public beta phase.

More information about HCS can be found at https://www.hashicorp.com/products/consul/service-on-azure/.


## Usage

Do not use the master branch as module source as this could include non working code. 
Always use a [released version](https://registry.terraform.io/modules/cpu601/hcs/azurerm) in the [Terraform registry](https://registry.terraform.io).

```hcl
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
```

## Azure Marketplace agreement

If you haven't deployed a HCS for Azure instance using the Azure Portal before you might want Terraform to accept the Marketplace agreement for you automatically.
To do so make sure to set `accept_marketplace_aggrement` to `true`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.24 |
| azurerm | >= 2.8.0 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.8.0 |
| random | >= 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accept\_marketplace\_aggrement | Automatically accept the Legal Terms for the HCS for Azure marketplace image. To fully automate the deployment this needs to be true. However, if you want to manually accept it using the Azure Portal or you have already deployed a HCS for Azure cluster before this needs to be set to 'false' | `bool` | `false` | no |
| application\_name | Provide a name for your managed application. application\_name can only contain letters and numbers, and be between 3 and 32 characters. | `string` | n/a | yes |
| consul\_cluster\_mode | Non-production clusters have a limited feature set and only a single Consul server. Production clusters are fully supported, full featured, and deploy with a minimum of three hosts. Supported values are PRODUCTION and DEVELOPMENT. | `string` | `"PRODUCTION"` | no |
| consul\_cluster\_name | Provide a name for your new Consul cluster. Name must meet the following criteria: 3-25 characters long, start with a letter, end with a letter or number and contain only letters, numbers, and hyphens. | `string` | n/a | yes |
| consul\_datacenter\_name | Provide a data center name for your new Consul cluster. Name must meet the following criteria: 3-25 characters long, start with a letter, end with a letter or number and contain only letters, numbers, and hyphens. | `string` | `"dc1"` | no |
| consul\_version | Select a version of Consul. The only supported value as of April 29, 2020 is v1.7.2 | `string` | `"v1.7.2"` | no |
| external\_endpoint | If enabled, the Consul UI and API will be exposed on a public IP address. | `bool` | `false` | no |
| managed\_resource\_group\_name | This resource group hols all the resources that are required by the managed application. | `string` | `null` | no |
| number\_of\_servers | The number of Consul servers to provision. | `number` | `3` | no |
| region | Choose the Azure region. As of April 29, 2020 only the regions East US (eastus), West US 2 (westus2), West Europe (westeurope) and North Europe (northeurope) are supported. | `string` | `"westeurope"` | no |
| resource\_group\_name | Name of the resource group that will be created to host the managed application HCS for Azure. | `string` | n/a | yes |
| vnet\_starting\_ip\_address | Confiure the initial IP address for the VNET CIDR range of your Consul cluster. A prefix of /24 will be applied to the created VNET. VNET starting IP address must fall in the range of: 10.\*.\*.\*, 172.[16-32].\*.\* or 192.168.\*.\*. | `string` | `"172.25.16.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_name | Name of the managed application that is HCS on Azure. |
| consul\_cluster\_name | n/a |
| consul\_url | URL of the HCS for Azure Consul Cluster API and UI. |
| get\_hcs\_config\_command | Azure CLI command to get HCS for Azure configuration which includes Consul API URL, Consul CA file, Consul config file and more. |
| managed\_resource\_group\_name | Name of the managed resource group create for HCS on Azure. |
| resource\_group\_name | Name of the resource group where HCS on Azure is deployed in. |
| subscription\_id | Id of the subscription HCS on Azure is running in. |