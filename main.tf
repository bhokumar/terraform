terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "cosmosdb_rg" {
  name     = "cosmosdb-resource-group"
  location = "eastus"
}

resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "cosmosdb-account"
  resource_group_name = azurerm_resource_group.cosmosdb_rg.name
  location            = azurerm_resource_group.cosmosdb_rg.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  enable_automatic_failover = false

  tags = {
    environment = "dev"
  }
}
