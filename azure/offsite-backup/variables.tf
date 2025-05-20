variable "storage_account_name" {
  description = "Name of the Azure Storage Account"
  type        = string
  default = "offsitebackup"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "northeurope"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default = "homelab"
}

variable "tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default = {
    env   = "homelab"
    owner = "admin"
  }
}

