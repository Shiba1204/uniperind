# modules/function_app/main.tf
resource "azurerm_app_service_plan" "plan" {
  name                = "${var.name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}
resource "azurerm_storage_account" "funcsa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_function_app" "func" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_app_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.funcsa.name
  storage_account_access_key = azurerm_storage_account.funcsa.primary_access_key

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = var.app_insights_key
    "KEYVAULT_URI"                   = var.key_vault_uri
  }

  tags = var.tags
}
