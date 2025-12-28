# modules/vm/variables.tf
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "subnet_id" { type = string }
variable "instances" {
  type = list(object({
    name    = string
    vm_size = string
    os_type = string
  }))
}
variable "diagnostics_workspace_id" { type = string }
variable "tags" { type = map(string) }
