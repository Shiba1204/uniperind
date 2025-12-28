terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstateprodsa001"
    container_name       = "tfstate"
    key                  = "prod/terraform.tfstate"
  }
}
