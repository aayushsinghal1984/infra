package azure.storage

import future.keywords.contains
import future.keywords.if

# Rule 1: Public blob access must be disabled
deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    r.change.after.allow_nested_items_to_be_public == true
    msg := sprintf(
        "[STORAGE] '%v': allow_nested_items_to_be_public must be false — public blob access is a data exposure risk",
        [r.address]
    )
}

# Rule 2: Shared access keys must be disabled (use Azure AD instead)
deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    r.change.after.shared_access_key_enabled == true
    msg := sprintf(
        "[STORAGE] '%v': shared_access_key_enabled must be false — use Azure AD authentication",
        [r.address]
    )
}

# Rule 3: 'Secure transfer required' must be enabled
deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    not r.change.after.https_traffic_only_enabled
    msg := sprintf(
        "[STORAGE] '%v': https_traffic_only_enabled must be true — 'Secure transfer required' must be enabled",
        [r.address]
    )
}

# Rule 4: Infrastructure encryption must be enabled (double encryption at rest)
deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    not r.change.after.infrastructure_encryption_enabled
    msg := sprintf(
        "[STORAGE] '%v': infrastructure_encryption_enabled must be true — enable infrastructure (double) encryption at rest",
        [r.address]
    )
}

# Rule 5: Blob soft delete must be enabled
blob_soft_delete_enabled(r) if {
    r.change.after.blob_properties[_].delete_retention_policy[_].days >= 1
}

deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    not blob_soft_delete_enabled(r)
    msg := sprintf(
        "[STORAGE] '%v': blob soft delete must be enabled — set blob_properties.delete_retention_policy.days >= 1",
        [r.address]
    )
}

# Rule 6: Container soft delete must be enabled
container_soft_delete_enabled(r) if {
    r.change.after.blob_properties[_].container_delete_retention_policy[_].days >= 1
}

deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    not container_soft_delete_enabled(r)
    msg := sprintf(
        "[STORAGE] '%v': container soft delete must be enabled — set blob_properties.container_delete_retention_policy.days >= 1",
        [r.address]
    )
}

# Rule 7: Minimum TLS version must be 1.2
deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    r.change.after.min_tls_version != "TLS1_2"
    msg := sprintf(
        "[STORAGE] '%v': min_tls_version must be 'TLS1_2' — TLS 1.0 and 1.1 are deprecated",
        [r.address]
    )
}

# Rule 8: A 'CanNotDelete' management lock must be applied
storage_has_delete_lock(sa_name) if {
    lock := input.resource_changes[_]
    lock.type == "azurerm_management_lock"
    lock.change.after.lock_level == "CanNotDelete"
    contains(lock.address, sa_name)
}

deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    sa_name := split(r.address, ".")[1]
    not storage_has_delete_lock(sa_name)
    msg := sprintf(
        "[STORAGE] '%v': a 'CanNotDelete' management lock must be applied to prevent accidental deletion",
        [r.address]
    )
}

# Rule 9: A 'ReadOnly' management lock must be applied
storage_has_readonly_lock(sa_name) if {
    lock := input.resource_changes[_]
    lock.type == "azurerm_management_lock"
    lock.change.after.lock_level == "ReadOnly"
    contains(lock.address, sa_name)
}

deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    sa_name := split(r.address, ".")[1]
    not storage_has_readonly_lock(sa_name)
    msg := sprintf(
        "[STORAGE] '%v': a 'ReadOnly' management lock should be applied to prevent unintended modifications",
        [r.address]
    )
}

# Rule 10: Geo-redundant replication must be used for critical storage accounts
geo_redundant_replication_types := {"GRS", "GZRS", "RAGRS", "RAGZRS"}

deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_storage_account"
    r.change.actions[_] in {"create", "update"}
    not geo_redundant_replication_types[r.change.after.account_replication_type]
    msg := sprintf(
        "[STORAGE] '%v': account_replication_type '%v' is not geo-redundant — use 'GRS', 'GZRS', 'RAGRS', or 'RAGZRS'",
        [r.address, r.change.after.account_replication_type]
    )
}
