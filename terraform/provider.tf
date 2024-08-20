provider "azurerm" {
  features {}
  subscription_id = var.subscription_id_prod
  alias = "prod"
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id_dev
  alias = "dev"
}