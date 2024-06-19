variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet" {
  description = "An object that defines a simple vNet"
  type = object({
    name = string
    cidr = string
  })
}

variable "subnets" {
  type = map(object({
    name_suffix = string
    newbits     = number
    netnum      = number
  }))
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet.cidr]
}

resource "azurerm_subnet" "main" {
  for_each = var.subnets

  name                 = format("%s-%s", var.vnet.name, each.value.name_suffix)
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [cidrsubnet(var.vnet.cidr, each.value.newbits, each.value.netnum)]
}

output "vnet" {
  value = {
    name          = azurerm_virtual_network.main.name
    address_space = azurerm_virtual_network.main.address_space
  }
}

output "subnets" {
  value = { for k, v in azurerm_subnet.main :
    k => {
      name             = v.name
      vnet             = v.virtual_network_name
      id               = v.id
      address_prefixes = v.address_prefixes
    }
  }
}
