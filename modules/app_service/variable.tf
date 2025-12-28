# modules/app_service/variables.tf
variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "plan_sku" { type = string }
variable "app_settings" { type = map(string) }
variable "log_analytics_workspace_id" { type = string }
variable "managed_identity_client_id" { type = string }
variable "tags" { type = map(string) }
