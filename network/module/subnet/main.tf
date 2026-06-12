resource "azurerm_subnet" "subnet" {
  for_each = var.subnets

  name                                          = each.value.subnet_name
  resource_group_name                           = each.value.resource_group_name
  virtual_network_name                          = each.value.virtual_network_name
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies = lookup(each.value, "private_endpoint_network_policies_enabled", true) ? "Enabled" : "Disabled"
  service_endpoints                             = lookup(each.value, "service_endpoints", null)
  private_link_service_network_policies_enabled = lookup(each.value, "private_link_service_network_policies_enabled", true)
  

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []

    content {
      name = delegation.value.name       
      service_delegation {
        name    = delegation.value.service_name #"Microsoft.Web/serverFarms" ya "Microsoft.DBforPostgreSQL/flexibleServers"
        actions = lookup(delegation.value, "actions", ["Microsoft.Network/virtualNetworks/subnets/join/action"])
      }
    }
  }
}