terraform {
  backend "azurerm" {
    resource_group_name  = "rg-storageaccount"
    storage_account_name = "sabckimterraform"
    container_name       = "demo-tfstate"
    key                  = "spoke/demo/network/spoke-demo-network.tfstate"
  }
}
