variable "tenant_id" {
  description = "The Azure tenant ID to use for authentication."
  type        = string
  default     = "9c6bcacb-3e9c-4db0-9979-cb8cecb0fb91"
}

variable "subscription_id" {
  description = "The Azure subscription ID to use for authentication."
  type        = string
  default     = "697e8019-073e-484a-bbdf-e0ba3cba83f1"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
  default     = "westeurope"
}
