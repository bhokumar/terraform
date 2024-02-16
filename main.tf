terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}




resource "azurerm_resource_group" "app_rg_1101_dev01" {
  name     = "RG_1101_DEV01"
  location = "Central India"
}



resource "azurerm_storage_account" "storage_dev01" {
  name                     = "storageaccount1101dev01"
  resource_group_name      = azurerm_resource_group.app_rg_1101_dev01.name
  location                 = azurerm_resource_group.app_rg_1101_dev01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"

  tags = {
    environment = "staging"
  }
  depends_on = [ azurerm_resource_group.app_rg_1101_dev01 ]
}

resource "azurerm_storage_container" "gsspcontainer" {
  name                  = "gsspcontainer"
  storage_account_name  = azurerm_storage_account.storage_dev01.name
  container_access_type = "blob"
  depends_on = [ azurerm_storage_account.storage_dev01 ]
}

resource "azurerm_storage_blob" "maintf" {
  name                   = "main.tf"
  storage_account_name   = azurerm_storage_account.storage_dev01.name
  storage_container_name = azurerm_storage_container.gsspcontainer.name
  type                   = "Block"
  source                 = "main.tf"
}