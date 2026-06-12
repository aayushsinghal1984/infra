Keyvault = {
  "kv-project-dev-001" = {
    KeyVaultName                    = "kv-project-dev-001"
    location                        = "Westus2"
    resource_group_name             = "myrg"
    enabled_for_disk_encryption     = true
    enabled_for_template_deployment = true
    enabled_for_deployment          = true
    purge_protection_enabled        = true
    soft_delete_retention_days      = 90
    enable_rbac_authorization       = true
    sku_name                        = "standard"
    # network_acls object attributes
    network_acls = {
      bypass         = "AzureServices"
      default_action = "Deny"
    }
  }
}
