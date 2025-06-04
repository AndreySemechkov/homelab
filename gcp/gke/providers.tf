provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  required_providers {
    google = {
      version = "6.35.0"
      source  = "hashicorp/google"
    }
  }

  required_version = ">1.9.0"
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
  alias   = "spot"
}

provider "helm" {
  kubernetes {
    host                   = module.gke.endpoint
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}
