
# Default both rules to fail (deny-by-default architecture)
default public_network_access_disabled := false
default network_access_rules_deny_by_default := false

# Public network access is Disabled
public_network_access_disabled if {
    some resource in input.resources
    resource.type == "Microsoft.Network/virtualNetworks"      
    resource.properties.publicNetworkAccess == "Disabled"
}

# Network Access Rules are set to Deny-by-default 
network_access_rules_deny_by_default if {
    some resource in input.resources
    resource.type == "Microsoft.Network/virtualNetworks"
    resource.properties.networkRules.defaultAction == "Deny"
}

deny contains msg if {
    not public_network_access_disabled
    msg := "Compliance Violation: Public network access must be Disabled on Virtual Networks (VNets)."
}

deny contains msg if {
    not network_access_rules_deny_by_default
    msg := "Compliance Violation: Network Access Rules must be set to Deny-by-default."
}
