terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-hello-world-app"
  location = "East US"
}

# Storage Account for Static Website
resource "azurerm_storage_account" "main" {
  name                     = "helloworldapp${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Outputs
output "website_url" {
  value = azurerm_storage_account.main.primary_web_endpoint
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "resource_group" {
  value = azurerm_resource_group.main.name
}