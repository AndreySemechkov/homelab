locals {

  k8s_account_roles = [
    "roles/container.admin",
    "roles/storage.admin",
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ]

  gke_cluster_zones = ["${var.region}-a", "${var.region}-b", "${var.region}-c"]

  # Extract first octet from subnet_cidr
  subnet_first_octet = split(".", var.subnet_cidr)[0]
}
