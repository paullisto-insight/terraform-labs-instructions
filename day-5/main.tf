terraform {
  required_version = ">= 0.14.8"
  required_providers {
    azurerm = {
      source  = "registry.terraform.io/hashicorp/azurerm"
      version = "> 2.74.0"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  backend "azurerm" {
    resource_group_name  = "terraform-arg-01"
    storage_account_name = "staaueeeiotpoc001"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    subscription_id      = "1ca11756-8ea2-4673-b264-0c7415ab9e34"
  }
}

provider "azurerm" {
  subscription_id = "1ca11756-8ea2-4673-b264-0c7415ab9e34"
  features {}
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    "publisher" : "cisco",
    "offer" : "cisco-c8000v",
    "sku" : "17_14_01a-payg-advantage",
    "version" : "latest"
  }
}

variable "admin_ssh_keys" {
  type = set(object({
    public_key = string
    username   = optional(string)
  }))
  default = []
}

resource "azurerm_resource_group" "cloud" {
  name     = "cloud-arg-01"
  location = "australiaeast"
}

resource "azurerm_virtual_network" "cloud" {
  name                = "vnt-cloud-01"
  location            = "australiaeast"
  resource_group_name = azurerm_resource_group.cloud.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "cloud" {
  name                 = "snt-cloud-01"
  resource_group_name  = azurerm_resource_group.cloud.name
  virtual_network_name = azurerm_virtual_network.cloud.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "time_sleep" "network" {
  depends_on = [azurerm_subnet.cloud]

  create_duration = "30s"
}


resource "azurerm_resource_group" "network" {
  name     = "network-arg-01"
  location = "australiaeast"
}

resource "azurerm_virtual_network" "network" {
  name                = "vnt-network-01"
  location            = "australiaeast"
  resource_group_name = azurerm_resource_group.network.name
  address_space       = ["10.0.0.0/16"]
}

locals {
  custom_data = base64encode(file("${path.module}/default_initial_config.tpl"))
  network_subnets = {
    subnet01 = {
      name                            = "network-snet-01"
      address_prefixes                = ["10.0.0.0/24"]
      enable_storage_service_endpoint = true
      create_public_ip                = true
    }
    subnet02 = {
      name             = "network-snet-02"
      address_prefixes = ["10.0.1.0/24"]
    }
    subnet03 = {
      name             = "network-snet-03"
      address_prefixes = ["10.0.2.0/24"]
    }
    subnet04 = {
      name             = "network-snet-04"
      address_prefixes = ["10.0.3.0/24"]
    }
  }
}

resource "azurerm_subnet" "network" {
  for_each = local.network_subnets

  name                 = each.value.name
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = each.value.address_prefixes
}

# Generate a random password 
resource "random_password" "this" {
  length           = 16
  min_lower        = 16 - 4
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  special          = true
  override_special = "_%@"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

locals {
  password            = random_password.this.result
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_public_ip" "this" {
  for_each = { for k, v in local.network_subnets : k => v if try(v.create_public_ip, false) }

  location            = "australiaeast"
  resource_group_name = local.resource_group_name
  name                = "pip-vm-cisco-8000v"
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
}

data "azurerm_public_ip" "this" {
  for_each = { for k, v in local.network_subnets : k => v
    if(!try(v.create_public_ip, false) && try(v.public_ip_name, null) != null)
  }

  name                = each.value.public_ip_name
  resource_group_name = try(each.value.public_ip_resource_group, null) != null ? each.value.public_ip_resource_group : local.resource_group_name
}


resource "azurerm_network_interface" "this" {
  for_each = { for k, v in local.network_subnets : k => v if can(v.name) }

  name                           = "vm-cisco-8000v631_z${substr(each.value.name, -1, 1)}"
  location                       = "australiaeast"
  resource_group_name            = local.resource_group_name
  accelerated_networking_enabled = true

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_virtual_network.network.id}/subnets/${each.value.name}"
    private_ip_address_allocation = try(each.value.private_ip_address, null) != null ? "Static" : "Dynamic"
    private_ip_address            = try(each.value.private_ip_address, null)
    public_ip_address_id          = try(azurerm_public_ip.this[each.key].id, data.azurerm_public_ip.this[each.key].id, null)
  }
}

resource "azurerm_marketplace_agreement" "default" {
  publisher = var.source_image_reference.publisher
  offer     = var.source_image_reference.offer
  plan      = var.source_image_reference.sku
}


resource "azurerm_linux_virtual_machine" "vm_linux" {

  admin_username                  = "localadmin"
  location                        = "australiaeast"
  name                            = "vm-cisco-8000v"
  network_interface_ids           = [for k, v in local.network_subnets : azurerm_network_interface.this[k].id]
  resource_group_name             = local.resource_group_name
  size                            = "Standard_DS4_v2"
  admin_password                  = local.password
  computer_name                   = "vm-cisco-8000v"
  disable_password_authentication = false
  zone                            = 1
  vtpm_enabled                    = false
  tags                            = {}
  secure_boot_enabled             = false


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 16
    name                 = "vm-cisco-8000v_OsDisk_1_d00c13ac99664c7e81aaa0e6f72b949b"
  }

  dynamic "admin_ssh_key" {
    for_each = { for key in var.admin_ssh_keys : jsonencode(key) => key }

    content {
      public_key = admin_ssh_key.value.public_key
      username   = coalesce(admin_ssh_key.value.username, "localadmin")
    }
  }

  source_image_reference {
    offer     = var.source_image_reference.offer
    publisher = var.source_image_reference.publisher
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  dynamic "plan" {
    for_each = ["one"]

    content {
      name      = var.source_image_reference.sku
      product   = var.source_image_reference.offer
      publisher = var.source_image_reference.publisher
    }
  }

  lifecycle {
    # Public keys can only be added to authorized_keys file for 'admin_username' due to a known issue in Linux provisioning agent.
    precondition {
      condition     = alltrue([for value in var.admin_ssh_keys : value.username == "localuser" || value.username == null])
      error_message = "`username` in var.admin_ssh_keys should be the same as `admin_username` or `null`."
    }
    ignore_changes = [custom_data, private_ip_addresses, public_ip_addresses, additional_capabilities, boot_diagnostics, identity]
  }
}

resource "time_sleep" "ot" {
  depends_on = [azurerm_subnet.network]

  create_duration = "30s"
}

resource "azurerm_resource_group" "ot" {
  name     = "ot-arg-01"
  location = "australiaeast"
}

resource "azurerm_virtual_network" "ot" {
  name                = "vnt-ot-01"
  location            = "australiaeast"
  resource_group_name = azurerm_resource_group.ot.name
  address_space       = ["10.2.0.0/16"]
}

resource "azurerm_subnet" "ot" {
  name                 = "snt-ot-01"
  resource_group_name  = azurerm_resource_group.ot.name
  virtual_network_name = azurerm_virtual_network.ot.name
  address_prefixes     = ["10.2.0.0/24"]
}
