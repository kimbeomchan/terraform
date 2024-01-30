terraform {
  backend "azurerm" {
    resource_group_name  = "rg-storageaccount"
    storage_account_name = "sabckimterraform"
    container_name       = "demo-tfstate"
    key                  = "hub/demo/firewall/hub-demo-fw.tfstate"
  }
}
