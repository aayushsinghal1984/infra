variable "subnets" {
  type = map(object({
    subnet_name                                   = string
    resource_group_name                           = string
    virtual_network_name                          = string
    address_prefixes                              = list(string)
    service_endpoints                             = optional(list(string), null)
    private_link_service_network_policies_enabled = optional(bool, true)
    
    
    delegation = optional(object({
      name         = string
      service_name = string
      actions      = optional(list(string), ["Microsoft.Network/virtualNetworks/subnets/join/action"])
    }), null)
  }))
}