variable "nsgsubnetassociation" {
    description = "A map of Subnet and Network Security Group IDs to associate them together."
    type = map(object({
    subnet_id                 = string
    network_security_group_id = string
  }))
 
}