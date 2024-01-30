terraform {
  # terraform version = "1.3.4"
  required_version = "1.3.4"

  required_providers {
    # azurerm provider = "3.29.1"
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "3.29.1"
      configuration_aliases = [azurerm.prd-subs]
    }
  }
}

# The default provider configuration
# Dev 프로바이더 정의
provider "azurerm" {
  subscription_id = "82697734-79a9-4155-8d33-7eac9d348041"
  features {}
}

# Additional provider configuration
# Dev 구독에서 Prd 구독을 참조하기 위해 해당 프로바이더 정의
provider "azurerm" {
  alias           = "prd-subs"
  subscription_id = "8c82895e-6d89-43f5-8414-29e2c36024f2"
  features {}
}
