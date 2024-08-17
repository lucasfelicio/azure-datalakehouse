terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.113.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Define locals
locals {
  prod_fixed = "estus-prod"
  dev_fixed = "estus-dev"
  current_date = formatdate("YYYYMMDD", timestamp())
}

# Deploy Resources Groups
resource "azurerm_resource_group" "rg_prod" {
    name = "rg-${local.prod_fixed}-${local.current_date}"
    location = var.region
}

resource "azurerm_resource_group" "rg_dev" {
    name = "rg-${local.dev_fixed}-${local.current_date}"
    location = var.region
}

# Deploy Azure Key Vault
resource "azurerm_key_vault" "akv_prod" {
  name = "akv-${local.prod_fixed}-${local.current_date}"
  location = var.region
  resource_group_name = azurerm_resource_group.rg_prod.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
}

resource "azurerm_key_vault" "akv_dev" {
  name = "akv-${local.dev_fixed}-${local.current_date}"
  location = var.region
  resource_group_name = azurerm_resource_group.rg_dev.name
  sku_name = "standard"
  tenant_id = data.azurerm_client_config.current.tenant_id
}

# Deploy Azure Data Factory Production
resource "azurerm_data_factory" "adf_prod" {
  name = "adf-${local.prod_fixed}-${local.current_date}"
  resource_group_name = azurerm_resource_group.rg_prod.name
  location = var.region  
}

# Deploy Azure Data Factory Develop
resource "azurerm_data_factory" "adf_dev" {
  name = "adf-${local.dev_fixed}-${local.current_date}"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location = var.region  
}

# Deploy Azure Storage Account
resource "azurerm_storage_account" "adls_prod" {
  name = "adlslucasdev"
  resource_group_name = azurerm_resource_group.rg_prod.name
  location = var.region
  account_tier = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled = true
}

resource "azurerm_storage_account" "adls_dev" {
  name = "adlslucasprod"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location = var.region
  account_tier = "Standard"
  account_replication_type = "LRS"
  is_hns_enabled = true
}

# Deploy Containers Data Lake
resource "azurerm_storage_container" "container_landing_zone" {
  name = "landing-zone"
  storage_account_name = azurerm_storage_account.adls_prod.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_bronze" {
  name = "bronze"
  storage_account_name = azurerm_storage_account.adls_prod.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_silver" {
  name = "silver"
  storage_account_name = azurerm_storage_account.adls_prod.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_gold" {
  name = "gold"
  storage_account_name = azurerm_storage_account.adls_prod.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_dev" {
  name = "dev"
  storage_account_name = azurerm_storage_account.adls_dev.name
  container_access_type = "private"
}

# Deploy Azure Databricks
resource "azurerm_databricks_workspace" "databricks_prod" {
  name = "adb-${local.prod_fixed}-${local.current_date}"
  resource_group_name = azurerm_resource_group.rg_prod.name
  location = var.region
  sku = "premium"
  managed_resource_group_name = "rg-adb-${local.prod_fixed}-${local.current_date}"  
}

resource "azurerm_databricks_workspace" "databricks_dev" {
  name = "adw-${local.dev_fixed}-${local.current_date}"
  resource_group_name = azurerm_resource_group.rg_dev.name
  location = var.region
  sku = "premium"
  managed_resource_group_name = "rg-adb-${local.dev_fixed}-${local.current_date}"  
}