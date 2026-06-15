# vnet.tftest.hcl

variables {
  resource_group = {
    "rg1" = {
      rg_name  = "rg1"
      location = "East US"
    }
  }

  vnets = {
    "vnet1" = {
      vnet_name           = "vnet1"
      address_space       = ["10.0.0.0/16"]
      location            = "East US"
      resource_group_name = "rg1"
    }
  }

  subnets = {
    "subnet1" = {
      subnet_name                                   = "subnet1"
      resource_group_name                           = "rg1"
      virtual_network_name                          = "vnet1"
      address_prefixes                              = ["10.0.1.0/24"]
      service_endpoints                             = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
      private_link_service_network_policies_enabled = true
    }
  }

  NSG = {
    "nsg1" = {
      NSGName             = "nsg1"
      location            = "East US"
      resource_group_name = "rg1"
      security_rules = [
        {
          name                        = "AllowHTTPInbound"
          priority                    = 100
          direction                   = "Inbound"
          access                      = "Allow"
          protocol                    = "Tcp"
          source_port_range           = "*"
          destination_port_range      = "80"
          source_address_prefix       = "10.0.0.0/16"
          destination_address_prefix  = "10.0.1.0/24"
          description                 = "Allow HTTP traffic from any source to any destination on port 80."
        },
        {
          name                        = "DenyAllOutbound"
          priority                    = 200
          direction                   = "Outbound"
          access                      = "Deny"
          protocol                    = "*"
          source_port_range           = "*"
          destination_port_range      = "*"
          source_address_prefix       = "10.0.0.0/16"
          destination_address_prefix  = "10.0.1.0/24"
          description                 = "Allow HTTP traffic from VNet to subnet1."
        }
      ]
    }
  }

  nsgsubnetassociation = {
    association1 = {
      subnet_name                 = "subnet1"
      virtual_network_name        = "vnet1"
      network_security_group_name = "nsg1"
      resource_group_name         = "rg1"
    }
  }
}

# ---------------------------------------------------
# RUN BLOCK: VNet plan validation
# ---------------------------------------------------
run "validate_vnet_plan" {
  command = plan

  # VNet address space check
  assert {
    condition     = var.vnets["vnet1"].address_space[0] == "10.0.0.0/16"
    error_message = "VNet address space does not match expected CIDR"
  }

  # VNet name check
  assert {
    condition     = var.vnets["vnet1"].vnet_name == "vnet1"
    error_message = "VNet name does not match expected value"
  }

  # VNet location check
  assert {
    condition     = var.vnets["vnet1"].location == "East US"
    error_message = "VNet location does not match expected region"
  }

  # VNet resource group binding check
  assert {
    condition     = var.vnets["vnet1"].resource_group_name == "rg1"
    error_message = "VNet is not associated with the correct resource group"
  }
}