terraform {
  backend "azurerm" {
    resource_group_name  = "demo-terraform-rg"
    storage_account_name = "demoterraformstga"
    container_name       = "demo-tfstate"
    key                  = "hub/demo/network/hub-demo-network-dev.tfstate"
  }
}