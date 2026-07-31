output "workspace_name" {
  description = "Name of the Machine Learning workspace."
  value       = azurerm_machine_learning_workspace.this.name
}

output "workspace_id" {
  description = "Resource ID of the Machine Learning workspace."
  value       = azurerm_machine_learning_workspace.this.id
}

output "storage_account_name" {
  description = "Name of the backing storage account."
  value       = azurerm_storage_account.this.name
}

output "container_registry_name" {
  description = "Name of the backing container registry."
  value       = azurerm_container_registry.this.name
}

output "application_insights_name" {
  description = "Name of the backing Application Insights instance."
  value       = azurerm_application_insights.this.name
}

output "key_vault_name" {
  description = "Name of the backing key vault."
  value       = azurerm_key_vault.this.name
}
