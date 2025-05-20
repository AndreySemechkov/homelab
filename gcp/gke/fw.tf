resource "google_compute_firewall" "fw_rules_egress" {
  project   =  var.project_id
  name      = "allow-egress"
  network   =  module.vpc.network_name
  direction = "EGRESS"

  allow {
    protocol = "all"
  }
}
