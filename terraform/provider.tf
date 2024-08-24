provider "azurerm" {
  features {}
  subscription_id = var.subscription_id_prd
  alias = "prd"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id_dev
  alias = "dev"
}