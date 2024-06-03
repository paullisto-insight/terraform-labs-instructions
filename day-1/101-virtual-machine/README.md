# Introduction 
We're ready to deploy our first complex resource using our resource group as a reference. In this tutorial we are going to deploy a virtual machine.

# Virtual Network
First we need a virtual network for our Virtual Machine. Add the following code to the bottom of our ```main.tf``` file.
```
resource "azurerm_virtual_network" "test-vnet" {
  name                = "terraform-test-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
}
```

# Virtual Network
Secondly, we need a subnet for our virtual network. Add the following code to the bottom of our ```main.tf``` file.
```
resource "azurerm_subnet" "test-subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.test-rg.name
  virtual_network_name = azurerm_virtual_network.test-vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}
```

# VM Network Interface
Next, we need a NIC for our virtual machine. Add the following code to the bottom of our ```main.tf``` file.
```
resource "azurerm_network_interface" "test-vm" {
  name                = "test-vm-nic01"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test-subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

# VM Network Interface
1.  Next, we need a sensitive variable for our virtual machine password. Add the following code to the bottom of our ```main.tf``` file.
```
variable "vm-password" {
    type = string
    sensitive = true
}
```
2.  Add a line to the ```terraform.tfvars``` for your VM password.
```
vm-password = ""
```
NOTE: even saving a password into a tfvars file is insecure. As a take away activity, or after you've successfully completed this lab, try using an ```azurerm_key_vault``` for this function instead. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault

# Virtual Machine
Finally, we are ready to add our virtual machine code. Add the following code to the bottom of our ```main.tf``` file.
```
resource "azurerm_windows_virtual_machine" "test-vm" {
  name                = "test-vm"
  resource_group_name = azurerm_resource_group.test-rg.name
  location            = azurerm_resource_group.test-rg.location
  size                = "Standard_D2s_v5"
  admin_username      = "adminuser"
  admin_password      = var.vm-password
  network_interface_ids = [
    azurerm_network_interface.test-vm.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
```

# Deploy the VM!
1. We're ready to deploy our Virtual Machine. Run ```terraform plan``` and ```terraform apply``` to deploy your virtual machine. Ask the instructor to validate your ```main.tf``` file if you recieve any errors.
2. Once the Virtual Machine is successfully deployed, the lab is completed. Once complete, continue to change the above virtual machine settings to try deploying the virtual machine with different settings (such as size), or for a bigger challenge, try and deploy an Azure Key Vault (as above) for the VM password secret.
