data "azurerm_client_config" "current" {}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  numeric = true
  special = false
}

########################################
# Storage Account (globally-unique name)
########################################

resource "azurerm_storage_account" "this" {
  name                = "st${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name

  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type

  min_tls_version = "TLS1_2"

  tags = var.tags
}

########################################
# Key Vault (globally-unique name)
########################################

resource "azurerm_key_vault" "this" {
  name                = "kv-${random_string.suffix.result}"
  location            = var.location
  resource_group_name = var.resource_group_name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = var.key_vault_sku_name

  purge_protection_enabled   = true
  soft_delete_retention_days = var.soft_delete_retention_days

  tags = var.tags
}

resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.this.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "GetRotationPolicy",
  ]

  secret_permissions = [
    "Get",
    "Set",
    "Delete",
    "List",
  ]
}

########################################
# Azure AI Foundry Hub
########################################

resource "azurerm_ai_foundry" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  storage_account_id = azurerm_storage_account.this.id
  key_vault_id       = azurerm_key_vault.this.id

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  depends_on = [
    azurerm_key_vault_access_policy.terraform,
  ]
}
