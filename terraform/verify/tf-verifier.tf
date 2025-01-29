#
# NO CHANGES ARE NECESSARY TO THIS FILE FOR THE DEMO TO WORK - PROCEED WITH CAUTION
#

# Configure the Azure provider

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false  # "True" protects against accidental deletion
    }
  }
}

#
# Create a resource group
#

resource "azurerm_resource_group" "rg" {
  name     = "MCAPS-TF-Validate"
  location = "eastus"
}
