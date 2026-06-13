variable "NSG" {
description = "Map of Network Security Groups with their respective dynamic security rules."
  type = map(object({    
    NSGName             = string
    location            = string
    resource_group_name = string
    
    
    security_rules = list(object({
      name                         = string
      priority                     = number
      direction                    = string # Inbound or Outbound
      access                       = string # Allow or Deny
      protocol                     = string # Tcp, Udp, Icmp, *, etc.   
      
      source_port_range            = optional(string, null)
      destination_port_range       = optional(string, null)
      source_address_prefix        = optional(string, null)
      destination_address_prefix   = optional(string, null)
      description                  = optional(string, null)     
      source_port_ranges           = optional(list(string), null)
      destination_port_ranges      = optional(list(string), null)
      source_address_prefixes      = optional(list(string), null)
      destination_address_prefixes = optional(list(string), null)    
     
      source_application_security_group_ids      = optional(list(string), null)
      destination_application_security_group_ids = optional(list(string), null)
    }))
  }))
 
}
