variable "storage_account_name" {
  description = "The name of the Azure Storage Account to create. Must be globally unique and between 3 and 24 characters in length, containing only lowercase letters and numbers."
  type        = string
  default     = "sttfstateedgewedemo001"
}