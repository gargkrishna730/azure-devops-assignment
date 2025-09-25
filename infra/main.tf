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
  length  = 6
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-hello-world-app"
  location = "East US 2"
}

# Static Web App
resource "azurerm_static_web_app" "main" {
  name                = "hello-world-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_tier            = "Free"
  sku_size            = "Free"
}

# Outputs
output "static_web_app_url" {
  value = "https://${azurerm_static_web_app.main.default_host_name}"
}

output "static_web_app_name" {
  value = azurerm_static_web_app.main.name
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}