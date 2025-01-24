
# This is used to randomize a unique name for storage accounts
resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "azurerm_resource_group" "homelab" {
  location = "northeurope"
  name     = "homelab"
}

resource "azurerm_resource_group" "terraform" {
  location = "germanywestcentral"
  name     = "terraform"
}

data "azurerm_client_config" "current" {}

module "tfstate_sa" {

  source = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.4.0" 

  account_replication_type   = "LRS"
  account_tier               = "Standard"
  account_kind               = "StorageV2"
  access_tier = "Hot"
  location                   = azurerm_resource_group.homelab.location
  resource_group_name        = azurerm_resource_group.terraform.name
  name = "terraformstate444"


  role_assignments = {
    role_assignment_1 = {
      role_definition_id_or_name       = "Owner"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },
  }
  allowed_copy_scope = "AAD"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  shared_access_key_enabled  = true
  public_network_access_enabled = true
  allow_nested_items_to_be_public    = false

  network_rules = null

  lock = {
    name = "delete"
    kind = "CanNotDelete"
  }

  blob_properties = {
    blob_delete_retention_enabled = true
    blob_delete_retention_days    = 14
    container_delete_retention_policy = {
      days = 30
    }
    versioning_enabled = true
  }

  tags = {
    env   = "homelab"
    owner = "admin"
  }
}

module "homelab_backup_sa" {

  source = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.4.0" 

  account_replication_type   = "LRS"
  account_tier               = "Standard"
  account_kind               = "StorageV2"
  access_tier = "Cool"
  location                   = azurerm_resource_group.homelab.location
  resource_group_name        = azurerm_resource_group.homelab.name
  name                       = "offsitebackup${random_string.this.result}"
  https_traffic_only_enabled = true
  min_tls_version            = "TLS1_2"
  shared_access_key_enabled  = true
  public_network_access_enabled = true
  allow_nested_items_to_be_public    = false

  network_rules = {
    bypass                     = ["Metrics"]
    default_action             = "Deny"
    ip_rules                   = [chomp(data.http.myip.response_body)]
  }

  role_assignments = {
    role_assignment_1 = {
      role_definition_id_or_name       = "Owner"
      principal_id                     = data.azurerm_client_config.current.object_id
      skip_service_principal_aad_check = false
    },
  }

  lock = {
    name = "delete"
    kind = "CanNotDelete"
  }

  blob_properties = {
    blob_delete_retention_enabled = true
    blob_delete_retention_days    = 14
    container_delete_retention_policy = {
      days = 30
    }
    last_access_time_enabled = true
  }

  containers = {
    blob_container0 = {
      name = "homelab-offsite-backup-container-0"
    }
  }

  tags = {
    env   = "homelab"
    owner = "admin"
  }
}