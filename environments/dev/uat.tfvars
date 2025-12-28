# environments/prod/prod.tfvars
location            = "eastus"
resource_group_name = "rg-azure-migration-prod"
project_name        = "azure-migration"
environment         = "prod"

tags = {
  Owner      = "CloudTeam"
  CostCenter = "FIN-IT-001"
}

# Replace with actual subnet IDs
subnet_aks_flink_id = "/subscriptions/.../subnets/aks-flink"
subnet_aks_micro_id = "/subscriptions/.../subnets/aks-micro"
subnet_apps_id      = "/subscriptions/.../subnets/apps"
subnet_vms_id       = "/subscriptions/.../subnets/vms"

k8s_version           = "1.29.7"
aks_system_vm_size    = "Standard_D4s_v5"
aks_system_node_count = 1
aks_user_vm_size      = "Standard_D4s_v5"
aks_user_node_count   = 2

la_retention_days     = 180
