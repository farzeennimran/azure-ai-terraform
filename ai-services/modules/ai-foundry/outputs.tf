output "ai_foundry_name" {
  description = "Name of the AI Foundry hub."
  value       = azurerm_ai_foundry.this.name
}

output "ai_foundry_id" {
  description = "Resource ID of the AI Foundry hub."
  value       = azurerm_ai_foundry.this.id
}

output "principal_id" {
  description = "Principal ID of the hub's system-assigned identity."
  value       = azurerm_ai_foundry.this.identity[0].principal_id
}

output "storage_account_name" {
  description = "Name of the backing storage account."
  value       = azurerm_storage_account.this.name
}

output "key_vault_name" {
  description = "Name of the backing key vault."
  value       = azurerm_key_vault.this.name
}
