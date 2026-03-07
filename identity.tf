resource "azurerm_user_assigned_identity" "uid" {
  name                = local.user_identity_name
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name

  tags = {
    environment = "Learning"
  }

  depends_on = [azurerm_resource_group.app_rg_1101_dev01]
}

output "user_identity_principal_id" {
  value       = azurerm_user_assigned_identity.uid.principal_id
  description = "Principal ID of the User Assigned Managed Identity"
}

output "user_identity_client_id" {
  value       = azurerm_user_assigned_identity.uid.client_id
  description = "Client ID of the User Assigned Managed Identity"
}
