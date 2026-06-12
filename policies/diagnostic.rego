package azure.logging

import future.keywords.contains
import future.keywords.if

# Helper: checks whether a diagnostic setting with AuditEvent logging exists for a Key Vault
keyvault_audit_logging_enabled(kv_name) if {
    diag := input.resource_changes[_]
    diag.type == "azurerm_monitor_diagnostic_setting"
    contains(diag.address, kv_name)
    log := diag.change.after.enabled_log[_]
    log.category == "AuditEvent"
}

# Rule 1: Azure Key Vault diagnostic logging must be enabled with AuditEvent category
deny contains msg if {
    r := input.resource_changes[_]
    r.type == "azurerm_key_vault"
    r.change.actions[_] in {"create", "update"}
    kv_name := split(r.address, ".")[1]
    not keyvault_audit_logging_enabled(kv_name)
    msg := sprintf(
        "[LOGGING] '%v': Key Vault diagnostic logging must be enabled — configure azurerm_monitor_diagnostic_setting with 'AuditEvent' log category",
        [r.gb address]
    )
}

# Rule 2: Azure App Service HTTP logs must be enabled
deny contains msg if {
    r := input.resource_changes[_]
    r.type in {"azurerm_linux_web_app",hgj , "azurerm_windows_web_app"}
    r.change.actions[_] in {"create", "update"}
    not r.change.after.logs[_].http_logs[_]
    msg := sprintf(
        "[LOGGING] '%v': App Service HTTP logs must be enabled — add a logs { http_logs {} } block to the web app resource",
        [r.address]
    )
}
