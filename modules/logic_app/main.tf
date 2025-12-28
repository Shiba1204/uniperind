# modules/logic_app/main.tf
resource "azurerm_logic_app_workflow" "logic" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  identity { type = "SystemAssigned" }
  tags = var.tags
}
