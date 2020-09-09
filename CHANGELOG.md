# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.1] - 2020-09.09

### Removed

- Removed `managed_vnet_id`, `managed_vnet_name`, `managed_vnet_region`, `managed_vnet_resource_group_name` outputs as managed VNET name can no longer be derived from the Consul cluster name. Use the [`azurerm_resources`](https://www.terraform.io/docs/providers/azurerm/d/resources.html) data resource could be used as an alternative.