# Variables Types

## Expected Outcome

* You will understand how to work with more complex variable types, includes maps, objects, and maps of objects.
* You will learn how to use resource meta-arguments for more dynamic Terraform code.

## How To

### Set Up our vNet Code
Add the following to our `main.tf` file:
1. 3 [variable blocks](https://www.terraform.io/language/values/variables):
    1. `resource_group_name` of [type](https://www.terraform.io/language/expressions/types) "string" (validation condition optional).
    1. `location` of [type](https://www.terraform.io/language/expressions/types) "string" (validation condition optional).
    1. `vnet_name` of [type](https://www.terraform.io/language/expressions/types) "string" (validation condition optional).
    1. `vnet_cidr` of [type](https://www.terraform.io/language/expressions/types) "string" (validation condition optional).
1. A [Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group).
1. Create an [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) resource block and use the value of the `vnet_cidr` variable as the value for the `address_space` property (NOTE it's a list type, so place the var between brackets `[]`) . DO NOT add any subnets (yet)!
1. Create a `dev.tfvars` file and fill out the values for your variables.
  Note: Your `vnet_cidr` should conform to [RFC1918](https://datatracker.ietf.org/doc/html/rfc1918#section-3) address space, be in CIDR format, and contain enough IP addresses for you to split it up cleanly into 3 subnets. I recommend a `/16` for this lab.
  For example, pick an address space such as `10.20.0.0/16` and if you get an error, try changing the number `20` in the second octet to a different number between 1 and 254.

### Refactor vNet Code
1. Refactor the variable blocks `vnet_name` and `vnet_cidr` into a single variable named `vnet`.
    1. Give the `vnet` variable a [description]().
    1. Make the variable an [object type] with two properties 1) name and 2) cidr
    1. Refactor the `azurerm_virtual_network` resource block properties:
          1. `name` will now be `var.vnet.name` (Note how we access object properties!)
          1. `address_space` will also need to be refactored to use the `cidr` property of the `vnet` variable object. Go ahead and make that change.
1. Add an ouput for the `vnet` with the values of the vnet name and address space. The output should also be an object.
1. Create a `dev.tfvars` and declare a value for your `vnet` object. **HINT** objects are declares using curly braces `{}`.

### Run Terraform Plan/Apply
1. init, plan, and apply your Terraform to deploy your vNet.

### Refactor Subnet Code
1. To make the subnets more flexible, we're going to create a `subnets` variable that is a map of objects. I map is like a list of similar typed things, in this case, you can think of it as a list of objects. Maps are not a fixed length, so we'll need to dynamically loop over the map in order to access each object's properties.
    1. Create a variable named `subnets` that is of type `map(object({})`.
    1. Within the `map(object({}))` curly braces, create 3 properties:
        1. `name_suffix`, which is a string we'll use to build the subnet name
        1. `newbits`, which is a number we'll use to calculate the subnet cidr
        1. `netnum`, which is also a number we'll use to calculate the subnet cidr
1. Refactor the `azurerm_subnet` resources. You're only going to need one `azurerm_subnet` resource block, so you can delete the other two.
    1. Rename the local name of your remaining `azurerm_subnet` block so it's local name is "main".
    1. Add a `for_each` meta-argument to the first line of the subnet resource block (within the curly braces) and assign its value to `var.subnets`
    1. Update the `format()` function that defines the `name` to accept two string parameters "%s" separated by a dash "-". Those string parameters are:
        1. The value of the vnet name (you can get this either from the variable or the "name" attribute of the virtual network resource).
        1. The value of the `name_suffix` property of the current subnet object in the loop. You will want to look at the [each object documentation](https://www.terraform.io/language/meta-arguments/for_each#each-value) to see how to reference the current value in your loop. Also recall how we references the `var.vnet` object properties. You'll use that same syntax to access the properties of the subnet object!
    1. Update the `address_prefixes` `cidrsubnet()` function, replacing the hardcoded "8" with the value of the `newbits` and the last parameter with the `netnum` value(both from the subnet object).
1. Add an output for `subnets`, the value of which will itself [be a loop that creates an object!](https://www.terraform.io/language/expressions/for#result-types).
    1. Include the subnet name, id, address_prefixes, and vnet id.
1. Update your `dev.tfvars` with 3 objects in the `subnets` variable to reflect the 3 subnets we had before - "web", "app" and "db".
    1. **HINT** Remember that a map contains key/value pairs of the same type. Our type in this case is an object. You will need a key for each object.
    ```
    subnets = {
      web = {
        name_suffix = ... 
      }
    }
    ```

### Run Terraform Plan/Apply
1. init, plan, and apply your Terraform to deploy your Subnets.
1. Why does Terraform want to destroy your existing Subnets?
1. Go ahead and run the apply, knowing that Terraform is performing these destructive actions... we'll be looking at this in more detail during our next lab.

### Prettify your code
1. Run `terraform fmt` to have the terraform cli auto-format your code. Thanks terraform cli!

### Targeted Destroy
1. Run `terraform state list` to see the resource addresses in your deployment statefile.
1. Run a targeted destroy on the "app" subnet.
1. Cleanup the rest of your resources by destroying them before finishing.

## Questions
1. In which cases might you want to leverage variables of type `map(object({}))`? Why?
1. Think of one other use for a variable of type object.

## Resources
* [Experimental Feature: optional object attributes](https://www.terraform.io/language/expressions/type-constraints#experimental-optional-object-type-attributes)
