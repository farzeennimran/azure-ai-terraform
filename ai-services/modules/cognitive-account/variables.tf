variable "name" {
  description = "Name of the Cognitive Services account."
  type        = string
}

variable "location" {
  description = "Azure region for the account."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group to create the account in."
  type        = string
}

variable "kind" {
  description = "Kind of Cognitive Services account (e.g. OpenAI, ComputerVision, SpeechServices)."
  type        = string
}

variable "sku_name" {
  description = "SKU of the account."
  type        = string
  default     = "S0"
}

variable "custom_subdomain_name" {
  description = "Custom subdomain for token-based auth. Defaults to the account name when null."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the account."
  type        = map(string)
  default     = {}
}
