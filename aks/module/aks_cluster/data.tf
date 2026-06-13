data "azurerm_resource_group" "rg_block" {
    for_each = var.aks
  name = each.value.resource_group_name
}
data "azurerm_virtual_network" "vnet_block" {
    for_each = var.aks
  name                = each.value.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rg_block[each.key].name
}
data "azurerm_subnet" "subnet_block" {
    for_each = var.aks
  name                 = each.value.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet_block[each.key].name
  resource_group_name  = data.azurerm_resource_group.rg_block[each.key].name
}

