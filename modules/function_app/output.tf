# modules/function_app/outputs.tf
output "function_app_id" { value = azurerm_linux_function_app.func.id }
