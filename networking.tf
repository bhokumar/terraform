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

resource "azurerm_subnet" "subnets" {
  count = var.number_of_subnets
  name                 = local.virtual_network.subnets[count.index].name
  resource_group_name  = azurerm_resource_group.app_rg_1101_dev01.name
  virtual_network_name = azurerm_virtual_network.virtual_network_dev1.name
  address_prefixes     = [local.virtual_network.subnets[count.index].address_prefix]
  depends_on = [ azurerm_virtual_network.virtual_network_dev1 ]
}