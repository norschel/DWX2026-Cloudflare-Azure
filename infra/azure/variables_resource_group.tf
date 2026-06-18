variable "resource_group_name_state" {
  description = "The name of the resource group where the state resources are deployed."
  type        = string
  default     = "rg-edge-before-azure-state"
}

variable "resource_group_name_demo" {
  description = "The name of the resource group where the demo resources are deployed."
  type        = string
}