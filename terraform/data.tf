data "azurerm_client_config" "current" {
  provider = azurerm.prd
}

data "azurerm_client_config" "current_dev" {
  provider = azurerm.dev
}
