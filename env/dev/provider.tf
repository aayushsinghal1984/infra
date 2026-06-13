terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.45.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "5e2ade1f-9bb8-4b4f-874f-5fd49f66c2fa"

  features {}
}

