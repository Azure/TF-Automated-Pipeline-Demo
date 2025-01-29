# Purpose: Create a variable group in Azure DevOps that references the Key Vault secrets for the DEV and PROD environments.

# dev variable group

data azurerm_resource_group dev_rg {
  provider = azurerm.dev
  name = "MCAPS-Automation-dev-demo"
}

data azurerm_key_vault dev {
  provider = azurerm.dev
  name                = "dev-kv-demo"
  resource_group_name = data.azurerm_resource_group.dev_rg.name
  depends_on = [ data.azurerm_resource_group.dev_rg ]
}

data azurerm_key_vault_secret dev_client_id {
  provider = azurerm.dev
  name         = "tf-client-id"
  key_vault_id = data.azurerm_key_vault.dev.id
  depends_on = [ data.azurerm_key_vault.dev ]
}

data azurerm_key_vault_secret dev_client_secret {
  provider = azurerm.dev
  name         = "tf-client-secret"
  key_vault_id = data.azurerm_key_vault.dev.id
    depends_on = [ data.azurerm_key_vault.dev ]
}

data azurerm_key_vault_secret dev_tenant_id {
  provider = azurerm.dev
  name         = "tf-tenant-id"
  key_vault_id = data.azurerm_key_vault.dev.id
    depends_on = [ data.azurerm_key_vault.dev ]
}

data azurerm_key_vault_secret dev_subscription_id {
  provider = azurerm.dev
  name         = "tf-subscription-id"
  key_vault_id = data.azurerm_key_vault.dev.id
    depends_on = [ data.azurerm_key_vault.dev ]
}


resource azuredevops_serviceendpoint_azurerm dev {
  project_id = azuredevops_project.main.id
  service_endpoint_name = "dev-azure-rm"

  credentials {
    serviceprincipalid     = data.azurerm_key_vault_secret.dev_client_id.value
    serviceprincipalkey    = data.azurerm_key_vault_secret.dev_client_secret.value
  }
  azurerm_spn_tenantid = data.azurerm_key_vault_secret.dev_tenant_id.value
  azurerm_subscription_id = data.azurerm_key_vault_secret.dev_subscription_id.value
  azurerm_subscription_name = "Terraform-Dev"
 depends_on = [ data.azurerm_key_vault_secret.dev_client_id, 
                data.azurerm_key_vault_secret.dev_client_secret, 
                data.azurerm_key_vault_secret.dev_tenant_id, 
                data.azurerm_key_vault_secret.dev_subscription_id ]
}

resource azuredevops_variable_group dev_secrets {
  project_id = azuredevops_project.main.id
  name       = "DEV-SECRETZ"
  description = "Secrets for the DEV environment"
  allow_access = true
  depends_on = [ azuredevops_serviceendpoint_azurerm.dev, data.azurerm_key_vault.dev, data.azurerm_key_vault_secret.dev_client_id, data.azurerm_key_vault_secret.dev_client_secret, data.azurerm_key_vault_secret.dev_tenant_id, data.azurerm_key_vault_secret.dev_subscription_id ] 

  key_vault {
    name = "dev-kv-demo"
    service_endpoint_id = azuredevops_serviceendpoint_azurerm.dev.id
  }

  variable {
    name  = "tf-client-id"
  }
  variable {
    name  = "tf-client-secret"
  }
  variable {
    name  = "tf-tenant-id"
  }
  variable {
    name  = "tf-subscription-id"
  }
  variable {
    name  = "tf-resource-group"
  }
  variable {
    name  = "tf-storage-account"
  }
  variable {
    name  = "tf-container"
  }

}

# prod variable group

data azurerm_resource_group prod_rg {
  provider = azurerm.prod
  name = "MCAPS-Automation-prod-demo"
}

data azurerm_key_vault prod {
  provider = azurerm.prod
  name                = "prod-kv-demo"
  resource_group_name = data.azurerm_resource_group.prod_rg.name
  depends_on = [ data.azurerm_resource_group.prod_rg ]
}

data azurerm_key_vault_secret prod_client_id {
  provider = azurerm.prod
  name         = "tf-client-id"
  key_vault_id = data.azurerm_key_vault.prod.id
  depends_on = [ data.azurerm_key_vault.prod ]
}

data azurerm_key_vault_secret prod_client_secret {
  provider = azurerm.prod
  name         = "tf-client-secret"
  key_vault_id = data.azurerm_key_vault.prod.id
    depends_on = [ data.azurerm_key_vault.prod ]
}

data azurerm_key_vault_secret prod_tenant_id {
  provider = azurerm.prod
  name         = "tf-tenant-id"
  key_vault_id = data.azurerm_key_vault.prod.id
    depends_on = [ data.azurerm_key_vault.prod ]
}

data azurerm_key_vault_secret prod_subscription_id {
  provider = azurerm.prod
  name         = "tf-subscription-id"
  key_vault_id = data.azurerm_key_vault.prod.id
    depends_on = [ data.azurerm_key_vault.prod ]
}


resource azuredevops_serviceendpoint_azurerm prod {
  project_id = azuredevops_project.main.id
  service_endpoint_name = "prod-azure-rm"

  credentials {
    serviceprincipalid     = data.azurerm_key_vault_secret.prod_client_id.value
    serviceprincipalkey    = data.azurerm_key_vault_secret.prod_client_secret.value
  }
  azurerm_spn_tenantid = data.azurerm_key_vault_secret.prod_tenant_id.value
  azurerm_subscription_id = data.azurerm_key_vault_secret.prod_subscription_id.value
  azurerm_subscription_name = "Terraform-Prod"
 depends_on = [ data.azurerm_key_vault_secret.prod_client_id, 
                data.azurerm_key_vault_secret.prod_client_secret, 
                data.azurerm_key_vault_secret.prod_tenant_id, 
                data.azurerm_key_vault_secret.prod_subscription_id ]
}

resource azuredevops_variable_group prod_secrets {
  project_id = azuredevops_project.main.id
  name       = "PROD-SECRETZ"
  description = "Secrets for the PROD environment"
  allow_access = true
  depends_on = [ azuredevops_serviceendpoint_azurerm.prod, data.azurerm_key_vault.prod, data.azurerm_key_vault_secret.prod_client_id, data.azurerm_key_vault_secret.prod_client_secret, data.azurerm_key_vault_secret.prod_tenant_id, data.azurerm_key_vault_secret.prod_subscription_id ] 

  key_vault {
    name = "prod-kv-demo"
    service_endpoint_id = azuredevops_serviceendpoint_azurerm.prod.id
  }

  variable {
    name  = "tf-client-id"
  }
  variable {
    name  = "tf-client-secret"
  }
  variable {
    name  = "tf-tenant-id"
  }
  variable {
    name  = "tf-subscription-id"
  }
  variable {
    name  = "tf-resource-group"
  }
  variable {
    name  = "tf-storage-account"
  }
  variable {
    name  = "tf-container"
  }
}