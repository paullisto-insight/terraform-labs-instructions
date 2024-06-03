terraform {
  required_version = ">= 1.3.1"

  backend "local" {
    path = "terraform.tfstate"
  }
}

variable "object" {
  type = object({
    name = string
    type = string
  })
  default = {
    name = "test-vm"
    type = "windows"
  }
}

resource "terraform_data" "object" {
  input = var.object
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

resource "terraform_data" "map" {
  input = var.map
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

resource "terraform_data" "list" {
  input = var.list
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

resource "terraform_data" "set" {
  input = var.set
}

output "set" {
  value = var.set
}
