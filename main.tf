terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.80.0"
    }
  }
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}


variable "vnet_cidr_range" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_prefixes" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "subnet_names" {
  type    = list(string)
  default = ["web", "database"]
}

provider "azurerm" {
  # Configuration options
    features {

    }
}

resource "azurerm_resource_group" "vnet-main" {
  name      = var.resource_group_name
  location  = var.location
}

module "vnet-main" {
  source                = "Azure/vnet/azurerm"
  version               = "2.5.0"
  resource_group_name   = azurerm_resource_group.vnet-main.name
  vnet_name             = var.resource_group_name
  address_spaces        = [var.vnet_cidr_range]
  subnet_prefixes       = var.subnet_prefixes
  subnet_names          = var.subnet_names
  nsg_id                = {}

   tags = {
       environment = "dev"
       contcenter= "it"
   }
   depends_on = [
     azurerm_resource_group.vnet-main
   ]
}
   
#############################################################################
# OUTPUTS
#############################################################################

output "vnet_id" {
    value = module.vnet-main.vnet_id
}