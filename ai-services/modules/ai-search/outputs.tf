output "search_service_name" {
  description = "Name of the search service."
  value       = azurerm_search_service.this.name
}

output "search_service_id" {
  description = "Resource ID of the search service."
  value       = azurerm_search_service.this.id
}

output "search_service_url" {
  description = "Endpoint URL of the search service."
  value       = "https://${azurerm_search_service.this.name}.search.windows.net"
}
