# create key vaults to store all secrets that will later be used by the ADO Project
# 
# NO CHANGES NEEDED HERE, CHANGE THESE VALUES WILL RESULT IN UNPREDICTABLE BEHAVIOR

resource azurerm_key_vault kvprod {
  provider                 = azurerm.prod
  name                     = var.prod_kv_name
  location                 = azurerm_resource_group.prod.location
  resource_group_name      = azurerm_resource_group.prod.name
  sku_name                 = "standard"
  tenant_id                = data.azurerm_subscription.prod.tenant_id
  purge_protection_enabled = false

  access_policy {
    tenant_id = data.azurerm_subscription.prod.tenant_id
    object_id = data.azuread_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Purge",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
    ]

    storage_permissions = [
      "Get",
      "List",
      "Delete",
      "Set",
      "Update",
    ]
  }

  access_policy {
    tenant_id = data.azurerm_subscription.prod.tenant_id
    object_id = azuread_service_principal.prod.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
    ]

  }

}

resource azurerm_key_vault_secret kvsclientidprod {
  provider     = azurerm.prod
  name         = "tf-client-id"
  value        = "${azuread_application.prod.application_id}"
  key_vault_id = azurerm_key_vault.kvprod.id

}

resource azurerm_key_vault_secret kvsclientsecretprod {
  provider     = azurerm.prod
  name         = "tf-client-secret"
  value        = "${azuread_application_password.prod.value}"
  key_vault_id = azurerm_key_vault.kvprod.id

}

resource azurerm_key_vault_secret kvstenantidprod {
  provider     = azurerm.prod
  name         = "tf-tenant-id"
  value        = "${data.azuread_client_config.current.tenant_id}"
  key_vault_id = azurerm_key_vault.kvprod.id
}

resource azurerm_key_vault_secret kvssubscriptionidprod {
  provider     = azurerm.prod
  name         = "tf-subscription-id"
  value        = "${var.prod_subscription_id}"
  key_vault_id = azurerm_key_vault.kvprod.id
}

resource azurerm_key_vault_secret kvsstraccntnameprod {
  provider     = azurerm.prod
  name         = "tf-storage-account"
  value        = "${azurerm_storage_account.prod.name}"
  key_vault_id = azurerm_key_vault.kvprod.id

}

resource azurerm_key_vault_secret kvsstrcontnameprod {
  provider     = azurerm.prod
  name         = "tf-container"
  value        = "${azurerm_storage_container.prod.name}"
  key_vault_id = azurerm_key_vault.kvprod.id

}

resource azurerm_key_vault_secret kvsstraccntrgprod {
  provider     = azurerm.prod
  name         = "tf-resource-group"
  value        = "${azurerm_resource_group.prod.name}"
  key_vault_id = azurerm_key_vault.kvprod.id

}

#
#
#   REPEAT ABOVE BUT FOR DEV - NEED TO FIX THIS TO BE A MODULE AT SOME POINT
#
#

resource azurerm_key_vault kvdev {
  provider                 = azurerm.dev
  name                     = var.dev_kv_name
  location                 = azurerm_resource_group.dev.location
  resource_group_name      = azurerm_resource_group.dev.name
  sku_name                 = "standard"
  tenant_id                = data.azurerm_subscription.dev.tenant_id
  purge_protection_enabled = false

  access_policy {
    tenant_id = data.azurerm_subscription.prod.tenant_id
    object_id = data.azuread_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Create",
      "Delete",
      "Purge",
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
    ]

    storage_permissions = [
      "Get",
      "List",
      "Delete",
      "Set",
      "Update",
    ]
  }

  access_policy {
    tenant_id = data.azurerm_subscription.dev.tenant_id
    object_id = azuread_service_principal.dev.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
    ]

  }

}

resource azurerm_key_vault_secret kvsclientiddev {
  provider     = azurerm.dev
  name         = "tf-client-id"
  value        = "${azuread_application.dev.application_id}"
  key_vault_id = azurerm_key_vault.kvdev.id

}

resource azurerm_key_vault_secret kvsclientsecretdev {
  provider     = azurerm.dev
  name         = "tf-client-secret"
  value        = "${azuread_application_password.dev.value}"
  key_vault_id = azurerm_key_vault.kvdev.id

}

resource azurerm_key_vault_secret kvstenantiddev {
  provider     = azurerm.dev
  name         = "tf-tenant-id"
  value        = "${data.azuread_client_config.current.tenant_id}"
  key_vault_id = azurerm_key_vault.kvdev.id
}

resource azurerm_key_vault_secret kvssubscriptioniddev {
  provider     = azurerm.dev
  name         = "tf-subscription-id"
  value        = "${var.dev_subscription_id}"
  key_vault_id = azurerm_key_vault.kvdev.id
}

resource azurerm_key_vault_secret kvsstraccntnamedev {
  provider     = azurerm.dev
  name         = "tf-storage-account"
  value        = "${azurerm_storage_account.dev.name}"
  key_vault_id = azurerm_key_vault.kvdev.id

}

resource azurerm_key_vault_secret kvsstrcontnamedev {
  provider     = azurerm.dev
  name         = "tf-container"
  value        = "${azurerm_storage_container.dev.name}"
  key_vault_id = azurerm_key_vault.kvdev.id

}

resource azurerm_key_vault_secret kvsstraccntrgdev {
  provider     = azurerm.dev
  name         = "tf-resource-group"
  value        = "${azurerm_resource_group.dev.name}"
  key_vault_id = azurerm_key_vault.kvdev.id

}