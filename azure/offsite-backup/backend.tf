terraform {
    backend "azurerm" {
        resource_group_name = "terraform"
        storage_account_name = "terraformstate444"
        container_name       = "tfstate"
        key = "northeurope/homelab-offsite-backup.tfstate"
    }
}