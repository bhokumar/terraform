

resource "azurerm_resource_group" "app_rg_1101_dev01" {
  name     = local.resource_group_name
  location = local.location
}
