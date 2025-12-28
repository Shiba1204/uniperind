# modules/aks/outputs.tf
output "id"                       { value = azurerm_kubernetes_cluster.this.id }
output "kube_config_raw"          { value = azurerm_kubernetes_cluster.this.kube_config_raw }
output "kube_admin_config_raw"    { value = azurerm_kubernetes_cluster.this.kube_admin_config_raw }
