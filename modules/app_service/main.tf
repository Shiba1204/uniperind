# modules/app_service/main.tf
resource "azurerm_app_service_plan" "plan" {
  name                = "${var.name}-plan"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    tier = "PremiumV3"
    size = var.plan_sku
  }
  tags = var.tags
}

resource "azurerm_app_service" "app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = azurerm_app_service_plan.plan.id

  app_settings = var.app_settings
  tags         = var.tags
}
