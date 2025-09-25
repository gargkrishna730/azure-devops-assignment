terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-hello-world-app"
  location = "West US 2"
}

# Static Web App (using correct resource)
resource "azurerm_static_web_app" "main" {
  name                = "hello-world-app"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_tier            = "Free"
}

# Outputs
output "web_app_url" {
  value = azurerm_static_web_app.main.default_host_name
}

output "resource_group" {
  value = azurerm_resource_group.main.name
}