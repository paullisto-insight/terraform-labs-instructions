# Introduction 
1.  To begin running Terraform commands, in VS Code click the Terminal tab in the top menu, and then click New Terminal.
2.  Within the terminal, browse to the location of your main.tf file we have been working on. It should be in its own folder (if you do not have admin rights on your computer, also make sure that ```terraform.exe``` is saved in this folder as well). Use the following code snippet (edit the path to suit your environment):
```
cd C:\path\to\folder\with\main.tf
```
3.  Run the command ```terraform init```
NOTE: if you do not have admin rights, you will need to replace ```terraform``` with ```.\terraform.exe```. This will need to be done across ALL LABS.

4. Terraform should successfully initiate and install the azurerm provider.

# Terraform Validate
The Terraform Validate command will validate the syntax of your code and ensure that it is correct prior to running plan.
```
terraform validate
```
NOTE: This will only detect Terraform syntax errors. It will not tell you if the code run will correctly against the resource provider.

# Terraform Plan
One of the major benefits of Terraform is the ability to print a plan of the changes that will occur on the resources before the ``terraform apply``` is run. Run the following code to see an output of the plan command:
```
terraform plan
```
Sometimes we will want to save the output of the terraform plan process. This output can be used as the input for a ```terraform apply```. To save a plan command to an output file, run the following code:
```
terraform plan -out tfplan
```

# Terraform Apply
It's now time to create our resource group! Run the following code to deploy the resource using our saved plan from the previous step:
```
terraform apply "tfplan"
```
You will have successfully completed the lab, if you see the following output:
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
