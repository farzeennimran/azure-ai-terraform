variable "subscription_id" {
  description = "Azure subscription ID to deploy the AI services into."
  type        = string
}

variable "org" {
  description = "Organisation / business-unit prefix used in resource names."
  type        = string
  default     = "bh"
}

variable "environment" {
  description = "Environment code used in resource names."
  type        = string
  default     = "prd"

  validation {
    condition     = contains(["dev", "tst", "stg", "prd"], var.environment)
    error_message = "environment must be one of: dev, tst, stg, prd."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "East US"
}

variable "tags" {
  description = "Additional tags merged on top of the common tags."
  type        = map(string)
  default     = {}
}
