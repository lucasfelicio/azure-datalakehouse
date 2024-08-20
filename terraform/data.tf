data "azurerm_client_config" "current" {
  provider = azurerm.prod
}

data "azurerm_client_config" "current_dev" {
  provider = azurerm.dev
}
