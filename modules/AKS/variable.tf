# modules/aks/variables.tf
variable "name" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "dns_prefix" { type = string }
variable "kubernetes_version" { type = string }
variable "vnet_subnet_id" { type = string }
variable "log_analytics_id" { type = string }
variable "system_node_pool" { type = object({
  vm_size    = string
  node_count = number
  max_pods   = number
  mode       = string
})}
variable "user_node_pools" {
  type = list(object({
    name             = string
    vm_size          = string
    node_count       = number
    enable_autoscale = bool
    min_count        = number
    max_count        = number
    max_pods         = number
  }))
}
variable "namespaces" { type = list(string) }
variable "workload_identity_id" { type = string }
variable "tags" { type = map(string) }
