variable "tenant_id" {
  description = "The Azure tenant ID to use for authentication."
  type        = string
}

variable "subscription_id" {
  description = "The Azure subscription ID to use for authentication."
  type        = string
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
  default     = "westeurope"
}
