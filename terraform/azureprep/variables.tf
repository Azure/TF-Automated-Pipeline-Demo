# This file contains the variables that will be used in the main configuration file for the demo

# NO CHANGES TO THIS FILE ARE NECESSARY FOR THE DEMO

# This is the subscription ID for the development environment - note this CAN be the same subscription as prod if you do not have access to multiple subscriptions
variable dev_subscription_id {
  description = "The subscription ID for the development environment"
  type        = string  
}

# This is the subscription ID for the production environment - note this CAN be the same subscription as dev if you do not have access to multiple subscriptions
variable prod_subscription_id {
  description = "The subscription ID for the production environment"
  type        = string  
}

# This is the alias of the user logged into Azure performing the demo, this is primarily to see the SP/app information but is necessary for the demo to work
variable app_owner {
  description = "this is the alias of the user logged into Azure performing the demo, this is primarily to see the SP/app information"
  type        = string
}

#
#   
#   
#   IT IS RECOMMENDED TO LEAVE THESE VALUES AS-IS FOR THE DEMO - PROCEED WITH CAUTION
#
#

# This is the name prefix and locations of the resource groups for the development and production environments

# CHANGING THE RG NAME WILL BREAK THE DEMO, there are references in the "variable-group.tf" file that will need to be updated
variable resource_group_name {
  description = "The name of the resource group"
  type        = string
  default = "MCAPS-Automation"
}

variable prod_rg_location {
  description = "The location of the production resource group"
  type        = string
  default = "westus2"
}

variable dev_rg_location {
  description = "The location of the development resource group"
  type        = string  
  default = "westus2"
}

# These are the names of the storage accounts for the development and production environments
variable prod_storage_account_name {
  description = "The name of the production storage account"
  type        = string
  default = "prodstrtfdemo"
  
}

variable dev_storage_account_name {
  description = "The name of the development storage account"
  type        = string
  default = "devstrtfdemo"
  
}

variable prod_kv_name {
  description = "The name of the production key vault"
  type        = string
  default = "prod-kv-demo"
}

variable dev_kv_name {
  description = "The name of the development key vault"
  type        = string
  default = "dev-kv-demo"
}