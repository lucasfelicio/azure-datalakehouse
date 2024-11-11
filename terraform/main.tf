terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.113.0"
    }
  }
}

# Define locals
locals {
  prd-fix   = "lucas-prd-001"
  dev-fix    = "lucas-dev-001"
}

# Ambiente de PRD
resource "azurerm_resource_group" "rg-prd" {
  provider = azurerm.prd
  name     = "rsg-${local.prd-fix}"
  location = var.region
}

resource "azurerm_key_vault" "akv-prd" {
  provider            = azurerm.prd
  name                = "akv-${local.prd-fix}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg-prd.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_data_factory" "adf-prd" {
  provider            = azurerm.prd
  name                = "adf-${local.prd-fix}"
  resource_group_name = azurerm_resource_group.rg-prd.name
  location            = var.region
}

# Ambiente DEV
resource "azurerm_resource_group" "rg-dev" {
  provider = azurerm.dev
  name     = "rsg-${local.dev-fix}"
  location = var.region
}

resource "azurerm_key_vault" "akv-dev" {
  provider            = azurerm.dev
  name                = "akv-${local.dev-fix}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg-dev.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_data_factory" "adf-dev" {
  provider            = azurerm.dev
  name                = "adf-${local.dev-fix}"
  resource_group_name = azurerm_resource_group.rg-dev.name
  location            = var.region
}