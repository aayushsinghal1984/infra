data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_block" {
  name      = "myrg"
  location  = "westus2"
}
resource "azurerm_key_vault" "keyVault" {
 # checkov:skip=CKV_AZURE_109:Firewall rules are dynamically handled and allowed via network_acls object variables
  # checkov:skip=CKV2_AZURE_32:Private endpoint is not required for this specific environment layer
  for_each                        = var.Keyvault
  name                            = each.value.KeyVaultName
  location                        = each.value.location
  resource_group_name             = azurerm_resource_group.rg_block.name
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  enabled_for_deployment          = each.value.enabled_for_deployment
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  purge_protection_enabled        = each.value.purge_protection_enabled
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  enable_rbac_authorization       = each.value.enable_rbac_authorization
  sku_name                        = each.value.sku_name  
  public_network_access_enabled   = false
  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Get", "List", "Set", "Delete"]
  }

  dynamic "network_acls" {
    for_each = each.value.network_acls != null ? [each.value.network_acls] : []
    content {
      bypass                     = network_acls.value["bypass"]
      default_action             = network_acls.value["default_action"]
      ip_rules                   = network_acls.value["ip_rules"]
      virtual_network_subnet_ids = network_acls.value["virtual_network_subnet_ids"]
    }
  }
}
