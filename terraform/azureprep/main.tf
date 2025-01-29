#
#   THIS SCRIPT CREATES ALL NECESSARY AZURE RESOURCES FOR THE PROJECT, REPO, and PIPELINES TERRAFORM SCRIPTS, NO CHANGES ARE NECESSARY IN THIS FILE
#

# MAKING CHANGES TO THIS FILE WILL RESULT IN UNPREDICTABLE BEHAVIOR

# IN THE EVENT YOU NEED TO TROUBLESHOOT STORAGE ACCOUNTS, SERVICE PRINCIPALS, ETC... YOU CAN UNCOMMENT THE FILE BLOCKS AT THE END OF THIS FILE

# Configure the Azure provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.4.0"
      configuration_aliases = [azurerm.prod, azurerm.dev]
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.36.0"
    }
  }
}

provider "azurerm" {
  alias           = "prod"
  subscription_id = var.prod_subscription_id
    features        {
       resource_group {
       prevent_deletion_if_contains_resources = false  # "True" protects against accidental deletion
       }
       key_vault {
       purge_soft_delete_on_destroy    = true
       recover_soft_deleted_key_vaults = true
       }
    }
}

provider "azurerm" {
  alias           = "dev"
  subscription_id = var.dev_subscription_id
    features        {
       resource_group {
       prevent_deletion_if_contains_resources = false  # "True" protects against accidental deletion
       }
       key_vault {
       purge_soft_delete_on_destroy    = true
       recover_soft_deleted_key_vaults = true
       }
    }
}

data "azurerm_subscription" "prod" {
  provider = azurerm.prod
}

data "azurerm_subscription" "dev" {
  provider = azurerm.dev
}

# Create the resource groups for dev and prod

resource "azurerm_resource_group" "prod" {
    provider = azurerm.prod
    name     = "${var.resource_group_name}-prod-demo"
    location = var.prod_rg_location
}

resource "azurerm_resource_group" "dev" {
    provider = azurerm.dev
    name = "${var.resource_group_name}-dev-demo"
    location = var.dev_rg_location
}

# Create Prod storage account and container, and export the storage account information to a file

resource "azurerm_storage_account" "prod" {
    provider = azurerm.prod
    name                     = var.prod_storage_account_name
    resource_group_name      = azurerm_resource_group.prod.name
    location                 = azurerm_resource_group.prod.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "prod" {
    provider              = azurerm.prod
    name                  = "tfstate"
    storage_account_name  = azurerm_storage_account.prod.name
    container_access_type = "private"
}

# Create Dev storage account and container, and export the storage account information to a file

resource "azurerm_storage_account" "dev" {
    provider = azurerm.dev
    name                     = var.dev_storage_account_name
    resource_group_name      = azurerm_resource_group.dev.name
    location                 = azurerm_resource_group.dev.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}

resource "azurerm_storage_container" "dev" { 
    provider = azurerm.dev
    name                  = "tfstate"
    storage_account_name  = azurerm_storage_account.dev.name
    container_access_type = "private"
}

#
# Service Principal creation for dev and prod
#

# Get the current user and client object IDs, necessary for the service principal owners
data "azuread_client_config" "current" {}

data "azuread_user" "owner" {
  user_principal_name = var.app_owner
}

locals {
  app_owners = [
    data.azuread_user.owner.object_id,
    data.azuread_client_config.current.object_id
  ]
}

# Service Principal for dev

resource "azuread_application" "dev" {
  display_name = "tfauto-dev-demo"
  owners       = local.app_owners
}

resource "azuread_service_principal" "dev" {
  application_id                = azuread_application.dev.application_id
  app_role_assignment_required  = false
  owners                        = local.app_owners
}

resource "azuread_service_principal_password" "dev" {
  display_name = "tfauto-dev-demo"
  service_principal_id = azuread_service_principal.dev.object_id
}

resource "azuread_application_password" "dev" {
  display_name = "tfauto-dev-demo secret"
  application_object_id = azuread_application.dev.object_id
}

# Dev Service Principal assigned to the Contributor role for the dev Subscription, and the Key Vault Secrets Officer role for the dev Key Vault

resource "azurerm_role_assignment" "ra-dev-sub" {
  provider              = azurerm.dev
  principal_id          = azuread_service_principal.dev.id
  role_definition_name  = "Contributor"
  scope                 = data.azurerm_subscription.dev.id
}

resource "azurerm_role_assignment" "ra-dev-kv" {
  provider              = azurerm.dev
  principal_id          = azuread_service_principal.dev.id
  role_definition_name  = "Key Vault Secrets Officer"
  scope                 = azurerm_key_vault.kvdev.id
}

# Prod Service Principal

resource "azuread_application" "prod" {
  display_name = "tfauto-prod-demo"
  owners       = local.app_owners
}

resource "azuread_service_principal" "prod" {
  application_id                = azuread_application.prod.application_id
  app_role_assignment_required  = false
  owners                        = local.app_owners
}

resource "azuread_service_principal_password" "prod" {
  display_name = "tfauto-prod-demo"
  service_principal_id = azuread_service_principal.prod.object_id
}

resource "azuread_application_password" "prod" {
  display_name = "tfauto-prod-demo secret"
  application_object_id = azuread_application.prod.object_id
}

# Prod Service Principal assigned to the Contributor role for the prod Subscription and the Key Vault Secrets Officer role for the prod Key Vault

resource "azurerm_role_assignment" "ra-prod-sub" {
  provider = azurerm.prod
  principal_id   = azuread_service_principal.prod.id
  role_definition_name = "Contributor"
  scope = data.azurerm_subscription.prod.id
}

resource "azurerm_role_assignment" "ra-prod-kv" {
  provider              = azurerm.prod
  principal_id          = azuread_service_principal.prod.id
  role_definition_name  = "Key Vault Secrets Officer"
  scope                 = azurerm_key_vault.kvprod.id
}

# Export the prod storage account information to a file, this is purely for troubleshooting purposes
# This file block is not necessary for the project to work, by default it is commented out but provides a useful reference for troubleshooting
# resource "local_file" "prod-storage" {
#   content = <<EOF
# resource_group = "${azurerm_resource_group.prod.name}"
# storage_account = "${azurerm_storage_account.prod.name}"
# container = "${azurerm_storage_container.prod.name}"
#   EOF
#   filename = "prod-storage.txt"
# }

# Export the dev storage account information to a file, this is purely for troubleshooting purposes
# This file block is not necessary for the project to work, by default it is commented out but provides a useful reference for troubleshooting
# resource "local_file" "dev-storage" {
#   content = <<EOF
# resource_group = "${azurerm_resource_group.dev.name}"
# storage_account = "${azurerm_storage_account.dev.name}"
# container = "${azurerm_storage_container.dev.name}"
#   EOF
#   filename = "dev-storage.txt"
# }

# export the dev azure_credentials for the .debug.tfvars file
# This file block is not necessary for the project to work, by default it is commented out but provides a useful reference for troubleshooting
# resource "local_file" "secret-dev" {
#   content = <<EOF
# client_id = "${azuread_application.dev.application_id}"
# client_secret = "${azuread_application_password.dev.value}"
# tenant_id = "${data.azuread_client_config.current.tenant_id}"
# subscription_id = "${var.dev_subscription_id}"
# EOF
#   filename = "dev-secret.txt"
# }

# export the prod azure_credentials for the .debug.tfvars file
# This file block is not necessary for the project to work, by default it is commented out but provides a useful reference for troubleshooting
# resource "local_file" "secret-prod" {
#   content = <<EOF
# client_id = "${azuread_application.prod.application_id}"
# client_secret = "${azuread_application_password.prod.value}"
# tenant_id = "${data.azuread_client_config.current.tenant_id}"
# subscription_id = "${var.prod_subscription_id}"
# EOF
#   filename = "prod-secret.txt"
# }