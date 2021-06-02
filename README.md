# Official HashiCorp Consul Service on Azure (HCS) Terraform Provider

As the official is now released this repository is now archived. Please migrate to the official provider as soon as possible.
For more information please have a look at the official provider documentation: https://registry.terraform.io/providers/hashicorp/hcs/latest/docs

# terraform-azurerm-hcs

This Terraform module will allow to deploy HashiCorp Consul Service (HCS) on Azure.

After you deployed your HCS cluster using this module additional steps are required to retrieve the Consul client configuration, certificates and to bootstrap the ACL system.
The following guide explains this process in more detail: <https://learn.hashicorp.com/tutorials/consul/hashicorp-consul-service-client-configuration>.

More information about HCS can be found at <https://www.hashicorp.com/products/consul/service-on-azure/>.

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
  resource_group_name = azurerm_resource_group.hcs.name
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
| http | >= 2.0.0 |
| random | >= 2.2.1 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.8.0 |
| http | >= 2.0.0 |
| random | >= 2.2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accept\_marketplace\_aggrement | Automatically accept the Legal Terms for the HCS for Azure marketplace image. To fully automate the deployment this needs to be true. However, if you want to manually accept it using the Azure Portal or you have already deployed a HCS for Azure cluster before this needs to be set to 'false' | `bool` | `false` | no |
| application\_name | Provide a name for your managed application. application\_name can only contain letters and numbers, and be between 3 and 32 characters. | `string` | n/a | yes |
| consul\_cluster\_mode | Non-production clusters have a limited feature set and only a single Consul server. Production clusters are fully supported, full featured, and deploy with a minimum of three hosts. Supported values are PRODUCTION and DEVELOPMENT. | `string` | `"DEVELOPMENT"` | no |
| consul\_cluster\_name | Provide a name for your new Consul cluster. Name must meet the following criteria: 3-25 characters long, start with a letter, end with a letter or number and contain only letters, numbers, and hyphens. | `string` | n/a | yes |
| consul\_datacenter\_name | Provide a data center name for your new Consul cluster. Name must meet the following criteria: 3-25 characters long, start with a letter, end with a letter or number and contain only letters, numbers, and hyphens. | `string` | `"dc1"` | no |
| consul\_version | Select a version of Consul. | `string` | `"v1.8.4"` | no |
| email | This email will be used by HashiCorp to notify you about system updates and operational issues. | `string` | n/a | yes |
| external\_endpoint | If enabled, the Consul UI and API will be exposed on a public IP address. | `bool` | `false` | no |
| managed\_resource\_group\_name | This resource group holds all the resources that are required by the managed application. | `string` | `null` | no |
| region | Choose the Azure region. As of November 20, 2020 the following Azure regions are supported: (US) East US, (US) East US 2, (US) Central US, (US) West US 2, (Europe) West Europe, (Europe) North Europe, (Europe) Central France, (Europe) South UK | `string` | `"westeurope"` | no |
| resource\_group\_name | Name of the resource group that will host the managed application HCS for Azure. This must exist before applying the Terraform module. | `string` | n/a | yes |
| vnet\_starting\_ip\_address | Configure the initial IP address for the VNET CIDR range of your Consul cluster. A prefix of /24 will be applied to the created VNET. VNET starting IP address must fall in the range of: 10.\*.\*.\*, 172.[16-32].\*.\* or 192.168.\*.\*. | `string` | `"172.25.16.0"` | no |

## Outputs

| Name | Description |
|------|-------------|
| application\_name | Name of the managed application that is HCS on Azure. |
| consul\_cluster\_name | Name of the managed Consul cluster. |
| consul\_url | URL of the HCS for Azure Consul Cluster API and UI. |
| get\_hcs\_config\_command | Azure CLI command to get HCS for Azure configuration which includes Consul API URL, Consul CA file, Consul config file and more. |
| install\_hcs\_az\_cli\_extension | HashiCorp provides an Azure CLI extension to interact with your HCS cluster. ou can install the extension directly from your shell using the az command. |
| managed\_resource\_group\_name | Name of the managed resource group that will be created by HCS on Azure. |
| managed\_vnet\_id | Id of the VNET the managed Consul cluster is connected to. |
| managed\_vnet\_name | Name of the VNET the managed Consul cluster is connected to. |
| managed\_vnet\_region | Region of the VNET the managed Consul cluster is connected to. |
| managed\_vnet\_resource\_group\_name | Name of the resource group of the VNET the managed Consul cluster is connected to. Should be the same as the managed\_resource\_group\_name output. |
| region | Region of the managed resource group that will be created by HCS on Azure. |
| resource\_group\_name | Name of the resource group where HCS on Azure is deployed in. |
| resource\_id | Full id for the Consul cluster resource |
| subscription\_id | Id of the subscription HCS on Azure is running in. |
