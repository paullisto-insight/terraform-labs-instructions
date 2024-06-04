# Introduction to Modules

## Expected Outcome

You will understand how to consume reusable Terraform modules from a Public Module Registry. The lessons you take from here can be applied to modules sourced from Private Module Registries (such as Terraform Cloud and Terraform Enterprise), git, and local sources.

## How To
You will create a `main.tf` file with the following:
1. A `terraform {}` block declaring the version of Terraform to use as well as the `azurerm` provider within the `required_providers` block.
1. An `azurerm` block for the provider configuration.
1. 3 [variable blocks](https://www.terraform.io/language/values/variables):
    1. `location` of [type](https://www.terraform.io/language/expressions/types) "string" (validation condition optional).
    1. `reource_group_name` of [type](https://www.terraform.io/language/expressions/types) "string" (validation condition optional).
1. See the [Azure VNet Module](https://registry.terraform.io/modules/Azure/vnet/azurerm/latest) on the Terraform Public Module Registry for _how_ to consume the module. Go ahead and create a `module "vnet" {}` block in `main.tf` andd fill out the 2 required inputs.
    1. You will need to specify the `source` of the module and it is best-practice to specify `version` as well.
        1. For Public/Private modules, you can use the `version` property of the `module` resource.
        1. For non-registry-sourced remote modules, there is a [special syntax for versioning](https://www.terraform.io/language/modules/sources#selecting-a-revision), they do not use the `version` property.
        1. Local modules do not provide a syntax for versioning.
1. Create a `dev.tfvars` file and enter values for `location` and `resource_group_name`. Save and close this file.

### Terraform Workflow and Modules
1. Run `terraform init` from the directory where `main.tf` lives. **NOTE** the deprecation errors are expected - this module needs updating!
1. Navigate to the `.terraform` directory, then `modules` directory. You should see a directory named `vnet` - notice how `terraform init` clones modules here!
1. Explore the `vnet` directory. Compare it to the [source on github](https://github.com/Azure/terraform-azurerm-vnet) what do you notice?
1. Run the plan/apply workflow, be sure to specify the `-var-file=dev.tfvars` and `-out=dev.tfplan` parameters.

### For an extra challenge.
- Consider how the VM code that we've been working on over the past two days could be turned into a module. A child module can simply be a nested folder of the terraform working directory that has it's own ```main.tf``` and other `.tf` files.
- [Calling a child module](https://developer.hashicorp.com/terraform/language/modules/syntax#calling-a-child-module)

## Questions
1. What did you learn about `terraform init` and modules?
1. How do local-sourced modules differ from remote-sourced modules?
1. What do you think happens with `terraform init` and a local-sourced module (HINT: local-sourced modules are not versioned and not required to be git-init'ed and thus cannot be cloned)

## Resources
- [Module Sources](https://www.terraform.io/language/modules/sources)
- [git sources](https://www.terraform.io/language/modules/sources#generic-git-repository)
