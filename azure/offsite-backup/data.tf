# This is used to randomize a unique name for storage accounts
resource "random_string" "this" {
  length  = 6
  special = false
  upper   = false
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "azurerm_client_config" "current" {}