# To begin... 
We're going to destroy our resource that we deployed in the previous lab. Run the following code:
```
terraform destroy
```
When prompted, type 'yes' and press enter to delete the resource group.

# Dynamic Input - Variables
1.  Using variables in Terraform allows our modules to become dyanmic and recieve varying inputs. This allows our modules to become repeatable code assets. To begin, we are going to create a variable input for our resource group name.
2.  We need to add a variable code block to our code. Add the following code snippet to the bottom of our ```main.tf``` file.
```
variable "resource_group_name" {
    type = string
    sensitive = false
}
```
NOTE: if you wish that the variable value is obscured in Terraform Plan and Terraform Apply outputs, set the ```sensitive``` value to ```true```.
3.  Secondly, in azurerm_resource_group code block, modify the ```name``` field so that it looks like below to use our new variable:
```
resource "azurerm_resource_group" "test-rg" {
  name     = var.resource_group_name
  location = "Australia East"
}
```
4. Save your ```main.tf``` file. It is now ready to recieve variable input.

# Setting a variable input manually
If variables have not been specified by any other means, when a Terraform Plan is run the command line will request the variable value. Review the code snippet below:
```
$terraform plan
var.resource_group_name
  Enter a value:
```
Try destroying your resource group using ```terraform destroy``` and then recreating using this input variable method.

# Setting a variable input in the command line
You can set variables when running the Terraform Plan and Terraform Apply commands using the ```-var``` switch. A code sample of this is shown below:
```
terraform plan -out tfplan -var="resource_group_name=terraform-test-rg"
```
Try destroying your resource group using ```terraform destroy``` and then recreating using this input variable method.

# Setting a variable input with tfvars
1.  Finally, we can use a variables file to set numerous input variables in an external file to run against our ```main.tf``` file.
2.  To begin, create a file named ```terraform.tfvars``` in the same folder as ```main.tf```.
3.  Open the file and add the following text, and then save and close the file:
```
resource_group_name = "terraform-test-rg"
```
4.  Run Terraform Plan as normal. So long as the file is named ```terraform.tfvars``` the file name does not need to be specified in the command:
```
terraform plan -out tfplan
```
5.  To use a custom tfvars file, the file name can be specified with the ```-var-file``` command. A code sample is shown below:
```
terraform plan -out tfplan -var-file='custom.tfvars'
```

Once you've tried all of the above variable input methods successfully, the lab is completed.
