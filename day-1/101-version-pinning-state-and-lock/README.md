# Introduction 
Version pinning enables us to protect our project resource API compatibility issues, or from future breaking API changes.

# Minimum AzureRM version
To set a minimum usage version of the AzureRM provider to ensure that all necessary resource APIs are present and compatible for your project, add the ```version``` line to the ```required_providers``` code block like so:
```
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.54.0"
    }
```

# Test
To test that the code change above has worked, run Terraform Init.
The output should look similar to the below:
```
terraform init

Initializing the backend...

Successfully configured the backend "local"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching ">= 3.54.0"...
- Installing hashicorp/azurerm v3.106.1...
- Installed hashicorp/azurerm v3.106.1 (signed by HashiCorp)
```
The line of code that says ```Finding hashicorp/azurerm versions matching ">= 3.54.0"...``` indicates that your code will now only utilise AzureRM Provider versions greater than 3.54.0.

# Minimum Terraform version
- To enforce a minimum version of the Terraform binary, add the following line below the ```required_providers``` code block:
```
  required_version = ">= 1.3.1"
```
- To complete the lab, request the instructor to review that your file is correct.
