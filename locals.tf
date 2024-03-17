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
        name = "subnet1"
        address_prefix = "10.0.1.0/24"
      },
      {
        name = "subnet2"
        address_prefix = "10.0.2.0/24"
      },
      {
        name = "subnet3"
        address_prefix = "10.0.3.0/24"
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