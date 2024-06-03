# Download Terraform. 
1.  Browse to the following link: https://developer.hashicorp.com/terraform/install#windows
2.  Extract the ZIP file that is downloaded. Copy the ```terraform.exe``` file to C:\temp\terraform. (create the folder if it doesn't exist)
3.  Install VS Code: https://code.visualstudio.com/download (this can be installed to the user profile if you don't have admin rights)
#OPTIONAL: Add Terraform Binary to Windows PATH Environment Variable (cannot be completed without admin rights).
1.  Search for "View Advanced System Settings" in the Start Menu (Windows 11). Alternatively, run sysdm.cpl from an elevated command prompt.
2.  Click the Advanced tab. Click Environment Variables.
3.  In the top list, scroll down to the PATH variable, select it, and click Edit. Note: If the PATH variable does not exist, click New and enter PATH for the Variable Name.
4.  In the Variable Value box, scroll to the end of the variable. If there is no semi-colon (;) at the end of the current path, add one, and then enter the path to the Terraform binary folder.
5.  Click OK to close each dialog box.
#ALTERNATIVELY: Once VS Code is installed, run the following command from a New Terminal inside VS Code (this will persist for the session only) ```$env:Path += ";C:\temp\terraform"```

# Getting Started
1.	Create a new folder for our first Terraform project.
2.	Open VS Code and create a new file called main.tf in this folder.
3.	Begin the file with the following code snippet:
```
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
```
This piece of code calls the Azure Resource Manager Terraform provider and installs it to your Terraform workspace directory.

# Add a backend
For this tutorial, we will save our state locally in our workspace directory.
The following code snippet configures our main.tf file to use a local backend. Add this below the required providers code from earlier.
```
  backend "local" {
    path = "terraform.tfstate"
  }
```
Finally, add a new line and a closing ```}``` to close the Terraform code block.

# Configure our Terraform provider
- Next we need to configure our AzureRM provider.
- If we wish to skip Azure Resource Providers and register them manually, we can add a line to our provider to prevent this.
- Here we can specify our Azure Subscription ID and the Tenant ID.
- Various features for the provider can be configured. A list of full feature configuration fields can be found here: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block
- For now, add the following to the end of our main.tf Terraform file:
```
provider "azurerm" {
  skip_provider_registration = "true"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  features {}
}
```

# Our first resource
- Before we can add any resources to our subscription, we first require an Azure Resource Group.
- Add the following code to the end of our main.tf Terraform file:
```
resource "azurerm_resource_group" "test-rg" {
  name     = "terraform-test-rg"
  location = "Australia East"
}
```
- This code, when executed, will create a Resource Group named terraform-test-rg.
- For now, request the instructor to review that your file is correct to complete the lab.
