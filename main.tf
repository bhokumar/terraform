terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.92.0"
    }
  }
}




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

}
resource "azurerm_resource_group" "app_rg_1101_dev01" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_network_security_group" "network_security_group_dev1" {
  name                = "network_security_group_dev01"
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name

depends_on = [ azurerm_resource_group.app_rg_1101_dev01 ]

}

resource "azurerm_virtual_network" "virtual_network_dev1" {
  name                = local.virtual_network.name
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name
  address_space       = [local.virtual_network.address_space]


  tags = {
    environment = "Production"
  }
  depends_on = [ azurerm_resource_group.app_rg_1101_dev01 ]
}

resource "azurerm_subnet" "subneta" {
  name                 = local.virtual_network.subnets[0].name
  resource_group_name  = azurerm_resource_group.app_rg_1101_dev01.name
  virtual_network_name = azurerm_virtual_network.virtual_network_dev1.name
  address_prefixes     = [local.virtual_network.subnets[0].address_prefix]
  depends_on = [ azurerm_virtual_network.virtual_network_dev1 ]
}


resource "azurerm_subnet" "subnetb" {
  name                 = local.virtual_network.subnets[1].name
  resource_group_name  = azurerm_resource_group.app_rg_1101_dev01.name
  virtual_network_name = azurerm_virtual_network.virtual_network_dev1.name
  address_prefixes     = [local.virtual_network.subnets[1].address_prefix]
  depends_on = [ azurerm_virtual_network.virtual_network_dev1 ]
}


resource "azurerm_network_interface" "app_interface_dev1" {
  name                = local.dev1_network_interface.name
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subneta.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ azurerm_subnet.subneta ]
}