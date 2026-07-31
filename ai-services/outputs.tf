output "resource_group_name" {
  description = "Name of the resource group holding all AI services."
  value       = azurerm_resource_group.ai.name
}

output "cognitive_account_endpoints" {
  description = "Map of Cognitive Services endpoints keyed by service."
  value       = { for k, m in module.cognitive : k => m.endpoint }
}

output "cognitive_account_ids" {
  description = "Map of Cognitive Services resource IDs keyed by service."
  value       = { for k, m in module.cognitive : k => m.resource_id }
}

output "search_service_url" {
  description = "Azure AI Search endpoint URL."
  value       = module.ai_search.search_service_url
}

output "ai_foundry_id" {
  description = "ID of the Azure AI Foundry hub."
  value       = module.ai_foundry.ai_foundry_id
}

output "machine_learning_workspace_id" {
  description = "ID of the Azure Machine Learning workspace."
  value       = module.machine_learning.workspace_id
}
