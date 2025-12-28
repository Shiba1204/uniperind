# environments/prod/main.tf
locals {
  prefix = "${var.project_name}-${var.environment}"
}

module "la_aks_flink" {
  source              = "../../modules/log_analytics"
  name                = "${locals.prefix}-la-aks-flink"
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_in_days   = var.la_retention_days
  tags                = var.tags
}

module "la_aks_micro" {
  source              = "../../modules/log_analytics"
  name                = "${locals.prefix}-la-aks-micro"
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_in_days   = var.la_retention_days
  tags                = var.tags
}

module "la_apps" {
  source              = "../../modules/log_analytics"
  name                = "${locals.prefix}-la-apps"
  location            = var.location
  resource_group_name = var.resource_group_name
  retention_in_days   = var.la_retention_days
  tags                = var.tags
}

module "aks_flink" {
  source              = "../../modules/aks"
  name                = "${locals.prefix}-aks-flink"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${locals.prefix}-flink"
  kubernetes_version  = var.k8s_version
  vnet_subnet_id      = var.subnet_aks_flink_id
  log_analytics_id    = module.la_aks_flink.workspace_id

  system_node_pool = {
    vm_size    = var.aks_system_vm_size
    node_count = var.aks_system_node_count
    max_pods   = 110
    mode       = "System"
  }

  user_node_pools = [
    {
      name             = "jobs"
      vm_size          = var.aks_user_vm_size
      node_count       = var.aks_user_node_count
      enable_autoscale = true
      min_count        = 1
      max_count        = 5
      max_pods         = 50
    }
  ]

  namespaces = ["flink-jobs", "flink-admin"]
  workload_identity_id = "" # optional
  tags = var.tags
}

module "aks_micro" {
  source              = "../../modules/aks"
  name                = "${locals.prefix}-aks-micro"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${locals.prefix}-micro"
  kubernetes_version  = var.k8s_version
  vnet_subnet_id      = var.subnet_aks_micro_id
  log_analytics_id    = module.la_aks_micro.workspace_id

  system_node_pool = {
    vm_size    = var.aks_system_vm_size
    node_count = var.aks_system_node_count
    max_pods   = 110
    mode       = "System"
  }

  user_node_pools = [
    {
      name             = "services"
      vm_size          = var.aks_user_vm_size
      node_count       = var.aks_user_node_count
      enable_autoscale = true
      min_count        = 2
      max_count        = 10
      max_pods         = 50
    }
  ]

  namespaces = ["microservices", "connect-adapters"]
  workload_identity_id = "" # optional
  tags = var.tags
}

module "app_service" {
  source                 = "../../modules/app_service"
  name                   = "${locals.prefix}-web"
  location               = var.location
  resource_group_name    = var.resource_group_name
  plan_sku               = "P1v3"
  app_settings           = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = "replace-with-key"
  }
  log_analytics_workspace_id = module.la_apps.workspace_id
  managed_identity_client_id = "" # optional
  tags = var.tags
}

module "function_app" {
  source                      = "../../modules/function_app"
  name                        = "${locals.prefix}-func"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  storage_account_name        = "${replace(locals.prefix, "-", "")}funcsa"
  log_analytics_workspace_id  = module.la_apps.workspace_id
  app_insights_key            = "replace-with-key"
  key_vault_uri               = "https://replace.vault.azure.net/"
  managed_identity_client_id  = "" # optional
  tags                        = var.tags
}

module "logic_app" {
  source                      = "../../modules/logic_app"
  name                        = "${locals.prefix}-logic"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  log_analytics_workspace_id  = module.la_apps.workspace_id
  key_vault_uri               = "https://replace.vault.azure.net/"
  managed_identity_client_id  = "" # optional
  tags                        = var.tags
}

module "vm" {
  source                    = "../../modules/vm"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  subnet_id                 = var.subnet_vms_id
  instances = [
    { name = "${locals.prefix}-vm-active",  vm_size = "Standard_D4s_v5", os_type = "linux" },
    { name = "${locals.prefix}-vm-passive", vm_size = "Standard_D4s_v5", os_type = "linux" }
  ]
  diagnostics_workspace_id  = module.la_apps.workspace_id
  tags                      = var.tags
}
