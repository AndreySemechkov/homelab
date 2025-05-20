terraform {
  backend "gcs" {
    bucket = "homelab-terraform-state-a1b2c3"
    prefix = "${var.region}/gke/terraform.tfstate"
  }
} 