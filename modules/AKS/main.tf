# modules/aks/main.tf
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "system"
    vm_size    = var.system_node_pool.vm_size
    node_count = var.system_node_pool.node_count
    max_pods   = var.system_node_pool.max_pods
    mode       = var.system_node_pool.mode
    vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_id
  }

  tags = var.tags
}

# Optional: additional user pools
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  for_each            = { for p in var.user_node_pools : p.name => p }
  name                = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size             = each.value.vm_size
  node_count          = each.value.node_count
  enable_auto_scaling = each.value.enable_autoscale
  min_count           = each.value.min_count
  max_count           = each.value.max_count
  max_pods            = each.value.max_pods
  vnet_subnet_id      = var.vnet_subnet_id
  mode                = "User"
  tags                = var.tags
}

# Namespaces via kubernetes provider (requires kubeconfig; shown as example)
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.this.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.this.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.this.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
}

resource "kubernetes_namespace_v1" "ns" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.key
  }
}
