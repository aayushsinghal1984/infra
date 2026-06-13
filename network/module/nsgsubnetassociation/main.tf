data "azurerm_subnet" "subnet_block" {
  for_each             = var.nsgsubnetassociation
  name                 = each.value.subnet_name  
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.resource_group_name
}

data "azurerm_network_security_group" "nsg" {
  for_each            = var.nsgsubnetassociation
  name                = each.value.network_security_group_name  
  resource_group_name = each.value.resource_group_name       
}

resource "azurerm_subnet_network_security_group_association" "nsgsubnet" {
  for_each                  = var.nsgsubnetassociation
  subnet_id                 = data.azurerm_subnet.subnet_block[each.key].id
  network_security_group_id = data.azurerm_network_security_group.nsg[each.key].id
}
