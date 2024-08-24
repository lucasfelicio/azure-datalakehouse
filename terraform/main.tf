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
  prod_fixed   = "eastus-lucas-prd"
  dev_fixed    = "eastus-lucas-dev"
}

# Ambientes de Produção
resource "azurerm_resource_group" "rg_prd" {
  provider = azurerm.prd
  name     = "rg-${local.prod_fixed}"
  location = var.region
}

resource "azurerm_key_vault" "akv_prd" {
  provider            = azurerm.prd
  name                = "akv-${local.prod_fixed}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg_prd.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_data_factory" "adf_prd" {
  provider            = azurerm.prd
  name                = "adf-${local.prod_fixed}"
  resource_group_name = azurerm_resource_group.rg_prd.name
  location            = var.region
}

resource "azurerm_storage_account" "adls_prd" {
  provider            = azurerm.prd
  name                = "adlseastuslucasprd"
  resource_group_name = azurerm_resource_group.rg_prd.name
  location            = var.region
  account_tier        = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled      = true
}

resource "azurerm_storage_container" "container_landing_zone" {
  provider             = azurerm.prd
  name                 = "landing-zone"
  storage_account_name = azurerm_storage_account.adls_prd.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_bronze" {
  provider             = azurerm.prd
  name                 = "bronze"
  storage_account_name = azurerm_storage_account.adls_prd.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_silver" {
  provider             = azurerm.prd
  name                 = "silver"
  storage_account_name = azurerm_storage_account.adls_prd.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_gold" {
  provider             = azurerm.prd
  name                 = "gold"
  storage_account_name = azurerm_storage_account.adls_prd.name
  container_access_type = "private"
}

resource "azurerm_databricks_workspace" "databricks_prd" {
  provider            = azurerm.prd
  name                = "adw-${local.prod_fixed}"
  resource_group_name = azurerm_resource_group.rg_prd.name
  location            = var.region
  sku                 = "premium"
  managed_resource_group_name = "rg-adw-${local.prod_fixed}"
}

# Ambientes de Desenvolvimento
resource "azurerm_resource_group" "rg_dev" {
  provider = azurerm.dev
  name     = "rg-${local.dev_fixed}"
  location = var.region
}

resource "azurerm_key_vault" "akv_dev" {
  provider            = azurerm.dev
  name                = "akv-${local.dev_fixed}"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg_dev.name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current_dev.tenant_id
}

resource "azurerm_data_factory" "adf_dev" {
  provider            = azurerm.dev
  name                = "adf-${local.dev_fixed}"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = var.region
}

resource "azurerm_storage_account" "adls_dev" {
  provider            = azurerm.dev
  name                = "adlseastuslucasdev"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = var.region
  account_tier        = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled      = true
}

resource "azurerm_storage_container" "container_dev" {
  provider             = azurerm.dev
  name                 = "develop"
  storage_account_name = azurerm_storage_account.adls_dev.name
  container_access_type = "private"
}

resource "azurerm_databricks_workspace" "databricks_dev" {
  provider            = azurerm.dev
  name                = "adw-${local.dev_fixed}"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location            = var.region
  sku                 = "premium"
  managed_resource_group_name = "rg-adw-${local.dev_fixed}"
}