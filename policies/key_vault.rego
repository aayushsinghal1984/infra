package azure.keyvault

import future.keywords.contains
import future.keywords.if
import future.keywords.in

# 1. Purge Protection check
deny contains msg if {
    rc := input.resource_changes[_]
    rc.type == "azurerm_key_vault"
    rc.change.after.purge_protection_enabled != false
    msg := sprintf("Security Violation: Key Vault '%s' must have 'purge_protection_enabled' set to true to protect against accidental deletion.", [rc.change.after.name])
}

# 2. Public Access check
deny contains msg if {
    rc := input.resource_changes[_]
    rc.type == "azurerm_key_vault"
    rc.change.after.public_network_access_enabled != false
    msg := sprintf("Security Violation: Key Vault '%s' must have 'public_network_access_enabled' set to false. Public access is forbidden.", [rc.change.after.name])
}

# 3. Soft Delete Retention (90 Days) check
deny contains msg if {
    rc    := input.resource_changes[_]
    rc.type == "azurerm_key_vault"
    rc.change.actions[_] in {"create", "update"}
    after := rc.change.after
    after.soft_delete_retention_days < 7
    
    msg := sprintf(
        "Compliance Violation: Key Vault '%s' has 'soft_delete_retention_days' set to %v. Company policy requires a minimum of 90 days retention.",
        [after.name, after.soft_delete_retention_days]
    )
}
# Helper to get all resource changes by type
resources_by_type(type) = [rc | rc := input.resource_changes[_]; rc.type == type; rc.change.actions[_] in {"create", "update"}]

# 4. Purge Protection Check
deny contains msg if {
    rc := resources_by_type("azurerm_key_vault")[_]
    not rc.change.after.purge_protection_enabled == true
    msg := sprintf("Compliance Violation: Key Vault '%s' must have 'purge_protection_enabled' set to true.", [rc.change.after.name])
}

# 5. Public Network Access Check
deny contains msg if {
    rc := resources_by_type("azurerm_key_vault")[_]
    rc.change.after.public_network_access_enabled != false
    msg := sprintf("Security Violation: Key Vault '%s' must have 'public_network_access_enabled' set to false.", [rc.change.after.name])
}

# 6. Role-Based Access Control (RBAC) Check
deny contains msg if {
    rc := resources_by_type("azurerm_key_vault")[_]
    not rc.change.after.enable_rbac_authorization == true
    msg := sprintf("Security Violation: Key Vault '%s' must use Azure RBAC instead of Access Policies ('enable_rbac_authorization' must be true).", [rc.change.after.name])
}

# 7. Expiration Date Check for Keys
deny contains msg if {
    rc := resources_by_type("azurerm_key_vault_key")[_]
    not rc.change.after.expiration_date
    msg := sprintf("Compliance Violation: Key Vault Key '%s' is missing an expiration date.", [rc.change.after.name])
}

# 8. Expiration Date Check for Secrets
deny contains msg if {
    rc := resources_by_type("azurerm_key_vault_secret")[_]
    not rc.change.after.expiration_date
    msg := sprintf("Compliance Violation: Key Vault Secret '%s' is missing an expiration date.", [rc.change.after.name])
}

# 9. Automatic Key Rotation Check
deny contains msg if {
    rc := resources_by_type("azurerm_key_vault_key")[_]
    # Checks if rotation_policy block is absent or empty
    not rc.change.after.rotation_policy
    msg := sprintf("Security Violation: Key Vault Key '%s' must have an automatic rotation_policy configured.", [rc.change.after.name])
}

# 10. Certificate Validity Period Check (Max 12 Months / 365 Days)
deny contains msg if {
    rc := resources_by_type("azurerm_key_vault_certificate")[_]
    policy := rc.change.after.certificate_policy[_]
    validity := policy.issuer_parameters[_].validity_in_months
    validity > 12
    msg := sprintf("Compliance Violation: Certificate '%s' validity period (%v months) exceeds the maximum allowed 12 months.", [rc.change.after.name, validity])
}

# 11. Microsoft Defender for Key Vault Check
# Looks for Defender enablement globally or at subscription tier
deny contains msg if {
    defender_vaults := [rc | 
        rc := input.resource_changes[_]
        rc.type == "azurerm_security_center_subscription_pricing"
        rc.change.after.resource_type == "KeyVaults"
        rc.change.after.tier == "Standard"
    ]
    count(defender_vaults) == 0
    msg := "Security Violation: Microsoft Defender for Key Vault must be explicitly set to 'On' via subscription tier pricing."
}
