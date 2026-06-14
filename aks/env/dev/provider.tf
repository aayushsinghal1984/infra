terraform {
  required_version = ">= 1.5.0"
  cloud {
    organization = "HCLIT"
    workspaces {    
    }
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.14.0"
    }
  }
}
provider "azurerm" {
  features {}
}
