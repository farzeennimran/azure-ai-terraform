variable "name" {
  description = "Name of the Azure Machine Learning workspace."
  type        = string
}

variable "location" {
  description = "Azure region for the workspace and its backing resources."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to create the resources in."
  type        = string
}

variable "key_vault_sku_name" {
  description = "SKU of the backing key vault."
  type        = string
  default     = "standard"
}

variable "storage_account_tier" {
  description = "Tier of the backing storage account."
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Replication type of the backing storage account."
  type        = string
  default     = "LRS"
}

variable "container_registry_sku" {
  description = "SKU of the backing container registry."
  type        = string
  default     = "Basic"
}

variable "application_insights_type" {
  description = "Application type for Application Insights."
  type        = string
  default     = "web"
}

variable "soft_delete_retention_days" {
  description = "Key vault soft-delete retention in days."
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags applied to all resources in the module."
  type        = map(string)
  default     = {}
}
