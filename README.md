# terraform-azurerm-hcs

This Terraform module will allow to deploy HashiCorp Consul Service (HCS) on Azure. HCS is currently in public beta phase.

More information about HCS can be found at https://www.hashicorp.com/products/consul/service-on-azure/.

## Usage

```hcl
provider "azurerm" {
  features {}
}

module "hcs" {
  source                       = "..."
  accept_marketplace_aggrement = true
  resource_group_name          = "my-rg-for-consul"
  application_name             = "hcs"
  consul_cluster_name          = "my-consul-cluster"
  external_endpoint            = true
}

output "hcs_config_command" {
  value = module.hcs.get_hcs_config_command
}
```
## Azure Marketplace agreement

If you haven't deployed a HCS instance using the Azure Portal before you might want Terraform to accept the Marketplace agreement for you automatically.
To do so make sure to set `accept_marketplace_aggrement` to `true`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.24 |
| azurerm | >= 2.7.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.7.0 |
| random | >= 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accept\_marketplace\_aggrement | Automatically accept the Legal Terms for the HCS marketplace image. To fully automate the deployment this needs to be true. However, if you want to manually accept it using the Azure Portal or you have already deployed a HCS cluster before this needs to be set to 'false' | `bool` | `false` | no |
| application\_name | Provide a name for your managed application. application\_name can only contain letters and numbers, and be between 3 and 32 characters. | `string` | n/a | yes |
| consul\_cluster\_mode | Non-production clusters have a limited feature set and only a single Consul server. Production clusters are fully supported, full featured, and deploy with a minimum of three hosts. Supported values are PRODUCTION and DEVELOPMENT. | `string` | `"PRODUCTION"` | no |
| consul\_cluster\_name | Provide a name for your new Consul cluster. Name must meet the following criteria: 3-25 characters long, start with a letter, end with a letter or number and contain only letters, numbers, and hyphens. | `string` | n/a | yes |
| consul\_datacenter\_name | Provide a data center name for your new Consul cluster. Name must meet the following criteria: 3-25 characters long, start with a letter, end with a letter or number and contain only letters, numbers, and hyphens. | `string` | `"dc1"` | no |
| consul\_version | Select a version of Consul. The only supported value as of April 29, 2020 is v1.7.2 | `string` | `"v1.7.2"` | no |
| external\_endpoint | If enabled, the Consul UI and API will be exposed on a public IP address. | `bool` | `false` | no |
| managed\_resource\_group\_name | This resource group hols all the resources that are required by the managed application. | `string` | `null` | no |
| number\_of\_servers | The number of Consul servers to provision. | `number` | `3` | no |
| region | Choose the Azure region. As of April 29, 2020 only the regions East US (eastus), West US 2 (westus2), West Europe (westeurope) and North Europe (northeurope) are supported. | `string` | `"westeurope"` | no |
| resource\_group\_name | Name of the resource group that will be created to host the managed application HCS. | `string` | n/a | yes |
| vnet\_starting\_ip\_address | Confiure the initial IP address for the VNET CIDR range of your Consul cluster. A prefix of /24 will be applied to the created VNET. VNET starting IP address must fall in the range of: 10.\*.\*.\*, 172.[16-32].\*.\* or 192.168.\*.\*. | `string` | `"172.25.16.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| get\_hcs\_config\_command | Azure CLI command to get HCS configuration which includes Consul API URL, Consul CA file, Consul config file and more. |