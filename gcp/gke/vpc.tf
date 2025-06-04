module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "11.1"

  project_id   = var.project_id
  network_name = "${var.environment}-${var.vpc_name}"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "${var.environment}-subnet-01"
      subnet_ip             = var.subnet_cidr
      subnet_region         = var.region
      subnet_private_access = true
      subnet_flow_logs      = true
    }
  ]
  secondary_ranges = {
    "${var.environment}-subnet-01" = [
      {
        range_name    = "pods"
        ip_cidr_range = "${local.subnet_first_octet}.1.0.0/16"
      },
      {
        range_name    = "services"
        ip_cidr_range = "${local.subnet_first_octet}.2.0.0/16"
      },
      {
        range_name    = "pods-02"
        ip_cidr_range = "${local.subnet_first_octet}.3.0.0/16"
      },
    ]
  }
}
# used for egress access to the internet from a private a subnet
module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 7.0"

  name    = "${var.environment}-router-gke"
  project = var.project_id
  region  = var.region
  network = module.vpc.network_id

  nats = [{
    name                               = "${var.environment}-nat-gke"
    source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  }]
}