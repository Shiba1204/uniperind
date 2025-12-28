# modules/logic_app/variables.tf
variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "log_analytics_workspace_id" { type = string }
variable "key_vault_uri" { type = string }
variable "managed_identity_client_id" { type = string }
variable "tags" { type = map(string) }
