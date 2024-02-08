

locals {
  resource_group_name = "RG_1101_DEV01"
  location = "Central India"
  storage_account_name = "storageaccount1101dev01"
  container_name = "gsspcontainer"
  blob_name = "main.tf"

  virtual_network = {
    name = "virtual_network_dev01"
    address_space = "10.0.0.0/16"
    subnets = [
      {
        name = "subneta"
        address_prefix = "10.0.0.0/24"
      },
      {
        name = "subnetb"
        address_prefix = "10.0.1.0/24"
      } 
    ]
  }
  dev1_network_interface = {
    name = "app_interface_dev1"
  }

  app_interface_dev11 = {
    name = "app_interface_dev11"
  }

  dev1_public_ip = {
    name = "app_ip_dev1"
    allocation_method = "Static"
  }

}
resource "azurerm_resource_group" "app_rg_1101_dev01" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_storage_account" "storage_account_dev01" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.app_rg_1101_dev01.name
  location                 = azurerm_resource_group.app_rg_1101_dev01.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  
}

resource "azurerm_storage_container" "dev1_containers" {
  
  for_each = toset([ "data", "files", "images" ])

  name                  = each.key
  storage_account_name  = azurerm_storage_account.storage_account_dev01.name
  container_access_type = "private"
  
}