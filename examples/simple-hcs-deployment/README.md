# Simple HCS  deployment

This directory will create a simple HCS deployment with only the required input parameters.

It will also create an Azure Resource Group to host the managed application.


## Usage

To run this example you need to execute:

```bash
terraform init
terraform plan
terraform apply
```

## Azure Marketplace agreement

If you haven't deployed a HCS for Azure instance using the Azure Portal before you might want Terraform to accept the Marketplace agreement for you automatically.
To do so make sure to set `accept_marketplace_aggrement` to `true`.
