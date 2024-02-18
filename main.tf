

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

resource "azurerm_subnet_network_security_group_association" "subneta_network_security_group_association_dev1" {
  subnet_id                 = azurerm_subnet.subneta.id
  network_security_group_id = azurerm_network_security_group.network_security_group_dev1.id
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

resource "azurerm_public_ip" "app_ip_dev1" {
  name                    = local.dev1_public_ip.name
  location                = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name     = azurerm_resource_group.app_rg_1101_dev01.name
  allocation_method       = local.dev1_public_ip.allocation_method
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "app_interface_dev1" {
  name                = local.dev1_network_interface.name
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subneta.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.app_ip_dev1.id
  }

  depends_on = [ azurerm_subnet.subneta ]
}

resource "azurerm_network_interface" "app_interface_dev11" {
  name                = local.app_interface_dev11.name
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subneta.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [ azurerm_subnet.subneta ]
}

resource "azurerm_windows_virtual_machine" "dev1_windows_server" {
  name                = "dev1appvm"
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  size                = "Standard_D2S_v3"
  admin_username      = "adminuser"
  admin_password = "Azure@123"
  network_interface_ids = [
    azurerm_network_interface.app_interface_dev1.id,
    azurerm_network_interface.app_interface_dev11.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  depends_on = [ azurerm_network_interface.app_interface_dev1, azurerm_resource_group.app_rg_1101_dev01 ]
}

output "subnet_id" {
  value = azurerm_subnet.subneta.id
}