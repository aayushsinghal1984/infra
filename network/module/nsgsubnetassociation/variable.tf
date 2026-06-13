variable "nsgsubnetassociation" {
  type = map(object({
    subnet_name                 = string 
    virtual_network_name        = string
    network_security_group_name = string
    resource_group_name         = string
  }))
}
