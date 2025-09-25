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

# Random suffix for unique names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-hello-world-app"
  location = "East US 2"

  tags = {
    Environment = "dev"
    Project     = "hello-world"
    ManagedBy   = "terraform"
  }
}

# Static Web App
resource "azurerm_static_site" "main" {
  name                = "swa-hello-world-${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  
  # Free tier
  sku_tier = "Free"
  sku_size = "Free"

  tags = {
    Environment = "dev"
    Project     = "hello-world"
    ManagedBy   = "terraform"
  }
}

# Outputs
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "static_web_app_name" {
  description = "Name of the Static Web App"
  value       = azurerm_static_site.main.name
}

output "static_web_app_url" {
  description = "Default URL of the Static Web App"
  value       = "https://${azurerm_static_site.main.default_host_name}"
}

output "deployment_token" {
  description = "Deployment token for the Static Web App"
  value       = azurerm_static_site.main.api_key
  sensitive   = true
}