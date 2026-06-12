variable "vnets" {
    description = "List of Virtual Networks"
    type        = map(object({
        vnet_name     = string
        address_space = list(string)
        location      = string
        resource_group_name = string
    }))
  
}