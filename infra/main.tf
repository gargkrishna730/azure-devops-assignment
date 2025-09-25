terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.3.0"
  
  # Backend configuration for remote state
  # Uncomment after first successful run if you encounter issues
  backend "azurerm" {
    resource_group_name  = "rg-hello-world-app"
    storage_account_name = "tfstatehelloworldapp"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-hello-world-app"
  location = "East US"
}

# Storage Account for Terraform State (with correct arguments)
resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstatehelloworldapp"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Correct way to disable public blob access
  public_network_access_enabled = false
  allow_nested_items_to_be_public = false
  
  min_tls_version = "TLS1_2"

  tags = {
    environment = "dev"
    purpose     = "terraform-state"
  }
}

# Storage Container for Terraform State
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# App Service Plan (Free Tier)
resource "azurerm_service_plan" "asp" {
  name                = "asp-hello-world-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "F1"  # Free tier

  tags = {
    environment = "dev"
  }
}

# Linux Web App (replaces deprecated azurerm_app_service)
resource "azurerm_linux_web_app" "app" {
  name                = "app-hello-world-unique-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
    
    # Always on must be false for Free tier
    always_on = false
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "18.0.0"
    "NODE_ENV"                     = "production"
  }

  tags = {
    environment = "dev"
  }
}

# Random string to ensure unique app name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Outputs
output "web_app_url" {
  description = "URL of the deployed web app"
  value       = "https://${azurerm_linux_web_app.app.default_hostname}"
}

output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "storage_account_name" {
  description = "Name of the storage account for Terraform state"
  value       = azurerm_storage_account.tfstate.name
}