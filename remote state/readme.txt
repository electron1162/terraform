Remote State file config via azure:

A. Create an storage account via terraform to store remote state file & backend configurations

main.tf
1. Terraform config
2. Variable - Resource group name(dynamic), location & naming prefix (default)
3. provider = azurerm
4. Resources = 
	i.   Random int generator : "random_integer" "sa_num"{} ,
	ii.  Resource group to store storage account : "azurerm_resource_group" "setup" {}, 
	iii. Actual storage account : "azurerm_storage_account" "sa" {}, 
	iv.  Container for storage account : "azurerm_storage_container" "ct" {}, 
       	 v.  SAS token to access storage account : data "azurerm_storage_account_sas" "state" {} 
	     Also having the below properties:
		> resource_types(service=true, container=true & object=true ) 
		> services (blob=true ,table, files, Queue)
		> permissions read  = true,write = true,delete= true,list  = true,add   = true,create= true,update= false,process= false)
		
5.Create a local provisioner to store the details which will be used to access the storage accounts such as:
	storage_account_name = "${azurerm_storage_account.sa.name}"
	container_name = "terraform-state"
	key = "terraform.tfstate"
	sas_token = "${data.azurerm_storage_account_sas.state.sas}"

6. Output the Storage account name & Resource group name

B. Migrate the local state file to remote

a. Update backend configurations
b. run terraform init
c. Confirm state migration

Backend config (you can not use variables in backend since it is the initialization process and terraform initilize variables post init thus resources values will be hardcoded)
** if you want to provide values during the fly you can use "-backend-config " flag with the key-value pair : ex : terraform init -backend-config="sas_token=njkhdsajhdhsajdsajdhsah12jh3j21312"



