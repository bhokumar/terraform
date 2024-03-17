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
  name                 = "subnet-${count.index}"
  resource_group_name  = azurerm_resource_group.app_rg_1101_dev01.name
  virtual_network_name = azurerm_virtual_network.virtual_network_dev1.name
  address_prefixes     = [local.virtual_network.subnets[count.index].address_prefix]
  depends_on = [ azurerm_virtual_network.virtual_network_dev1 ]
}


resource "azurerm_network_security_group" "network_security_group_dev1" {
  name                = "network_security_group_dev01"
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name

 depends_on = [ azurerm_resource_group.app_rg_1101_dev01 ]

 security_rule {
     name = "RDP"
     priority = 1000
     direction = "Inbound"
     access = "Allow"
     protocol = "Tcp"
     source_port_range = "*"
     destination_port_range = "3389"
     source_address_prefix = "*"
     destination_address_prefix = "*"
   }

  security_rule {
        name = "HTTP"
        priority = 1001
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = "80"
        source_address_prefix = "*"
        destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "network_security_group_association_dev1" {
  count = var.number_of_subnets
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.network_security_group_dev1.id

  depends_on = [ azurerm_virtual_network.virtual_network_dev1, azurerm_network_security_group.network_security_group_dev1 ]
}
