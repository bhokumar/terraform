data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = local.keyvault_name
  location                    = azurerm_resource_group.app_rg_1101_dev01.location
  resource_group_name         = azurerm_resource_group.app_rg_1101_dev01.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  # Access policy for the User Assigned Managed Identity
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.uid.principal_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete"
    ]

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete"
    ]

    certificate_permissions = [
      "Get",
      "List"
    ]
  }

  # Access policy for the current user / service principal (Terraform caller)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Backup",
      "Recover",
      "Restore",
      "Purge"
    ]

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Update",
      "Import",
      "Backup",
      "Recover",
      "Restore",
      "Purge"
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Update",
      "Import",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "Purge"
    ]
  }

  # Access policy for the portal user (Bhoopendra Kumar)
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.portal_user_object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Backup",
      "Recover",
      "Restore",
      "Purge"
    ]

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Update",
      "Import",
      "Backup",
      "Recover",
      "Restore",
      "Purge"
    ]

    certificate_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Update",
      "Import",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "Purge"
    ]
  }

  tags = {
    environment = "Learning"
  }

  depends_on = [
    azurerm_resource_group.app_rg_1101_dev01,
    azurerm_user_assigned_identity.uid
  ]
}

output "keyvault_uri" {
  value       = azurerm_key_vault.kv.vault_uri
  description = "The URI of the Key Vault"
}
