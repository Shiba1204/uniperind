# environments/prod/variables.tf
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "project_name" { type = string }
variable "environment" { type = string }
variable "tags" { type = map(string) }

# Networking (flat vNet assumed in platform; skip here for brevity)
variable "subnet_aks_flink_id" { type = string }
variable "subnet_aks_micro_id" { type = string }
variable "subnet_apps_id" { type = string }
variable "subnet_vms_id" { type = string }

# AKS
variable "k8s_version" { type = string }
variable "aks_system_vm_size" { type = string }
variable "aks_system_node_count" { type = number }
variable "aks_user_vm_size" { type = string }
variable "aks_user_node_count" { type = number }

# Log Analytics
variable "la_retention_days" { type = number }
