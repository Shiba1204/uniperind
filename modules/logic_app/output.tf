# modules/logic_app/outputs.tf
output "logic_app_id" { value = azurerm_logic_app_workflow.logic.id }
