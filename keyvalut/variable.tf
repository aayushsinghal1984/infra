variable "Keyvault" {
  type = map(object({
    KeyVaultName                    = string
    location                        = string
    resource_group_name             = string
    enabled_for_disk_encryption     = bool
    enabled_for_template_deployment = bool
    enabled_for_deployment          = bool
    purge_protection_enabled        = bool
    soft_delete_retention_days      = number
    enable_rbac_authorization       = bool
    sku_name                        = string
    network_acls = object({
      bypass         = string
      default_action = string
      virtual_network_subnet_ids = optional(list(string))
      ip_rules                   = optional(list(string))
    })
  }))
}
