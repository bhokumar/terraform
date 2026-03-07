resource "azurerm_api_management" "apim" {
  name                = local.apim_name
  location            = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name = azurerm_resource_group.app_rg_1101_dev01.name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku_name

  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uid.id]
  }

  tags = {
    environment = "Learning"
  }

  depends_on = [
    azurerm_resource_group.app_rg_1101_dev01,
    azurerm_user_assigned_identity.uid
  ]
}

output "apim_gateway_url" {
  value       = azurerm_api_management.apim.gateway_url
  description = "The APIM Gateway URL"
}

output "apim_portal_url" {
  value       = azurerm_api_management.apim.portal_url
  description = "The APIM Developer Portal URL"
}

output "apim_management_api_url" {
  value       = azurerm_api_management.apim.management_api_url
  description = "The APIM Management API URL"
}

output "apim_identity_principal_id" {
  value       = azurerm_api_management.apim.identity[0].principal_id
  description = "The Principal ID of the APIM System Assigned Managed Identity"
}

output "apim_identity_tenant_id" {
  value       = azurerm_api_management.apim.identity[0].tenant_id
  description = "The Tenant ID of the APIM System Assigned Managed Identity"
}
