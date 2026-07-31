variable "name" {
  description = "Name of the Azure AI Search service."
  type        = string
}

variable "location" {
  description = "Azure region for the search service."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to create the search service in."
  type        = string
}

variable "sku" {
  description = "SKU of the search service."
  type        = string
  default     = "basic"
}

variable "replica_count" {
  description = "Number of replicas."
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Number of partitions."
  type        = number
  default     = 1
}

variable "local_authentication_enabled" {
  description = "Whether API key (local) authentication is enabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the search service."
  type        = map(string)
  default     = {}
}
