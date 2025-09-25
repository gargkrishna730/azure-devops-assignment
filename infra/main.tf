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
  location = "East US"
}

# App Service Plan (Free Tier)
resource "azurerm_service_plan" "main" {
  name                = "asp-hello-world-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  os_type             = "Linux"
  sku_name            = "F1"  # Free tier
}

# Linux Web App
resource "azurerm_linux_web_app" "main" {
  name                = "app-hello-world-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
    always_on = false  # Required for free tier
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18.0.0"
    "NODE_ENV"                     = "production"
  }
}

# Outputs
output "web_app_url" {
  description = "URL of the web application"
  value       = "https://${azurerm_linux_web_app.main.default_hostname}"
}

output "web_app_name" {
  description = "Name of the web application"
  value       = azurerm_linux_web_app.main.name
}