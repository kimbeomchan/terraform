terraform {
  # terraform version = "1.3.4"
  required_version = "1.3.4"

  required_providers {
    # azurerm provider = "3.29.1"
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.29.1"
    }
    tls = {
      version = "4.0.4"
    }
    random = {
      version = "3.4.3"
    }
  }
}

provider "azurerm" {
  features {}
}