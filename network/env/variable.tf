variable "resource_group" {
  description = "List of Resource Group"
  type = map(object({
    rg_name  = string
    location = string
  }))
}

variable "vnets" {
  description = "List of Virtual Networks"
  type = map(object({
    vnet_name           = string
    address_space       = list(string)
    location            = string
    resource_group_name = string
  }))
}

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

variable "NSG" {
  type = map(object({
    NSGName             = string
    location            = string
    resource_group_name = string
    
    security_rules = list(object({
      name                                       = string
      priority                                   = number
      direction                                  = string 
      access                                     = string 
      protocol                                   = string 
      source_port_range                          = optional(string, null)
      destination_port_range                     = optional(string, null)
      source_address_prefix                      = optional(string, null)
      destination_address_prefix                 = optional(string, null)
      description                                = optional(string, null)     
      source_port_ranges                         = optional(list(string), null)
      destination_port_ranges                    = optional(list(string), null)
      source_address_prefixes                    = optional(list(string), null)
      destination_address_prefixes               = optional(list(string), null)    
      source_application_security_group_ids      = optional(list(string), null)
      destination_application_security_group_ids = optional(list(string), null)
    }))
  }))

  description = "Map of Network Security Groups with their respective dynamic security rules."
}

variable "nsgsubnetassociation" {
  type = map(object({
    subnet_name                 = string 
    virtual_network_name        = string
    network_security_group_name = string
    resource_group_name         = string
  }))
}
