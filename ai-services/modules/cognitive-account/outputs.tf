output "name" {
  description = "Name of the Cognitive Services account."
  value       = azurerm_cognitive_account.this.name
}

output "endpoint" {
  description = "Endpoint URL of the account."
  value       = azurerm_cognitive_account.this.endpoint
}

output "resource_id" {
  description = "Resource ID of the account."
  value       = azurerm_cognitive_account.this.id
}

output "principal_id" {
  description = "Principal ID of the system-assigned identity."
  value       = azurerm_cognitive_account.this.identity[0].principal_id
}
