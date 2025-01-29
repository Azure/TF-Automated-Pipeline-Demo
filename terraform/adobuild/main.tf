terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.4.0"
      configuration_aliases = [azurerm.prod, azurerm.dev]
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 0.5.0"
    }
  }
}

provider "azuredevops" {
  org_service_url = var.service_url
  personal_access_token = var.personal_access_token
}

provider azurerm {
  alias           = "prod"
  subscription_id = var.production_subscription_id
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
  subscription_id = var.development_subscription_id
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


resource "azuredevops_git_repository" "tfrepo" {
  project_id = azuredevops_project.main.id
  name       = "TF-Generated-Repo"   # this is the name of the repository that will be created
  initialization {
    init_type   = "Import"
    source_type = "Git"
    source_url  = "${var.repository_template_url}.git"
  }
}

resource "azuredevops_project" "main" {
  name = "TF-Pipeline-Demo"     # this is the name of the project that will be created
  description = "this is a poc for multiple environments and backends"
}