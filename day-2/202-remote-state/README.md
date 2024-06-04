# Introduction 
1.  Next, We are going to learn about using Remote State.
2.  In our tutorial yesterday, we created a terraform backend using ```"local"```. Today, we will change that backend to use ```"remote"```.
3.  If you haven't already, run ```terraform destroy``` to remove all of your resources from yesterday.
4.  Change our terminal directory to the day 1 tutorial, and identify the following code:
```
  backend "local" {
    path = "terraform.tfstate"
  }
```
5. Replace this code with the following:
```
  backend "azurerm" {
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    key                  = "terraform.tfstate"
    subscription_id      = ""
  }
```

6. Next, browse to http://portal.azure.com and log in.

7. At the top of the web page in the search bar, type ```Storage Accounts``` and under services click ```Storage Accounts```.

8. In the top left hand corner until the title Storage Accounts, click + Create.

9. On the first tab, next to the Resource Group field, you will see a link to ```Create New```. Fill this out with a new Resource Group name.

10. Under the ```Storage account name:``` field type a name for your storage account. It must be less that 24 char long with no spaces or special characters including dashes.

11. Click next and assume the default values until you reach the ```Data Protection``` tab. On this page, untick the options for soft delete. NOTE: YOU WOULD NOT DO THIS IN A PRODUCTION ENVIRONMENT

12. Once all these fields are populated, click Review and Create.

13. Once the resource is created, you will see a ```Go to Resource``` button. Click that, or if you've browsed away from the page, search for your storage account name in the top bar.

14. In the left hand menu of the resource, click ```Containers``` under ```Data storage```.

15. On this page, create a new Container and call it ```terraform```.

16. You can now populate your remote backend like this:
```
  backend "azurerm" {
    resource_group_name  = "newresourcegroupname"
    storage_account_name = "newstorageaccountname"
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    subscription_id      = "85d7f2c7-ab31-4b4d-be57-5f625ecc1aaa"
  }
```

17. Run ```terraform init```, ```terraform plan``` and ```terraform apply```. The resources will now be using the remote state file.