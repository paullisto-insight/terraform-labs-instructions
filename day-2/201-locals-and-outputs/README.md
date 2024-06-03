# Introduction 
1.  In this tutorial we will learn about maps, sets, lists, and objects.
2.  Below are some code examples of each input type:
```
variable "object" {
  type = object{
    name = string
    type = string
  }
  default = {
    name = "test-vm"
    type = "windows"
  }
}

output "object" {
  value = var.object
}

variable "map" {
  type = map(string)
  default = {
    "1" = "a"
    "2" = "b"
    "3" = "c"
  }
}

output "map" {
  value = var.map
}

variable "list" {
  type = list(string)
  default = [
    "foo",
    "bar",
  ]
}

output "list" {
  value = var.list
}

variable "set" {
  type = set(string)
  default = [
    "foo",
    "bar",
  ]
}

output "set" {
  value = var.set
}
```
3. Copy the files in the tutorial folder to a folder on your computer. Don't use the same folder as our project from yesterday.

4. Open a terminal and ```cd C:\path\to\folder``` to change to the folder with the files. Remember to run your $env commands again this morning to fix your terraform and az PATH.

5. Try adding your own values to the terraform.tfvars file and then running ```terraform plan``` and ```terraform apply```. Remember to run ```terraform init``` first.

6. Look at the VM resource that you deployed in yesterday's tutorial at https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine and consider how maps, objects, sets and lists could be applied to setting variables.

7. Experiment by adding ```tags = ``` to the VM resource from yesterday and setting the tags using a ```map``` variable.