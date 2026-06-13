# Package name must align with your pipeline's target module folder structure
package azure.vnets

import future.keywords.in

# Deny Rule 1: Fails if Public Network Access is enabled
deny[{"id": "VNET-001", "msg": msg}] {
    some resource in input.resource_changes
    resource.type == "azurerm_virtual_network"
    resource.change.actions[_] != "delete"
    
    # Check if public network access is explicitly set to true
    resource.change.after.public_network_access_enabled == true
    
    msg := sprintf("Compliance Violation: Public network access must be Disabled on VNet: '%v'.", [resource.address])
}

#  Fails if VNet Encryption is not strictly enforced (Corrected Azure Schema Attribute)
deny[{"id": "VNET-002", "msg": msg}] {
    some resource in input.resource_changes
    resource.type == "azurerm_virtual_network"
    resource.change.actions[_] != "delete"
    
    # Azure VNet schema verification: Check if encryption enforcement is missing or insecure
    resource.change.after.vnet_encryption_enforcement != "DropUnencrypted"
    
    msg := sprintf("Compliance Violation: VNet Encryption Enforcement must be set to 'DropUnencrypted' on VNet: '%v'.", [resource.address])
}

# Evaluates and renders successful compliances in your summary table
passed_checks[{"id": "VNET-PASS", "msg": msg}] {
    some resource in input.resource_changes
    resource.type == "azurerm_virtual_network"
    resource.change.actions[_] != "delete"
    
    # Ensures both security baselines are fully met before marking as PASS
    resource.change.after.public_network_access_enabled == false
    resource.change.after.vnet_encryption_enforcement == "DropUnencrypted"
    
    msg := sprintf("Security Verified: VNet '%v' complies with all corporate infrastructure perimeter rules.", [resource.address])
}
