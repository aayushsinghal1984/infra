
package azure.network.security

import rego.v1
target_services := [
    "Microsoft.KeyVault/vaults",
    "Microsoft.Storage/storageAccounts",
    "Microsoft.Sql/servers",
]

default allow := false
allow if {
    count(deny) == 0
}
deny contains msg if {    
    some service_resource in input.resources
    service_resource.type in target_services 
    not has_private_endpoint(service_resource.id)       
    msg := sprintf("Compliance Violation: Private Endpoints are used to access {service}. Missing private endpoint for resource: %v", [service_resource.id])
}

has_private_endpoint(service_id) if {
    some endpoint in input.resources
    endpoint.type == "Microsoft.Network/privateEndpoints"
     some connection in endpoint.properties.privateLinkServiceConnections
    connection.properties.privateLinkServiceId == service_id
}
