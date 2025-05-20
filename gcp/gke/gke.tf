module "gke" {
  version                    = "36.3.0"
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  name                       = "${var.environment}-${var.region}-${var.cluster_name}"
  ip_range_pods              = module.vpc.subnets_secondary_ranges[0][0].range_name
  additional_ip_range_pods   = [module.vpc.subnets_secondary_ranges[0][2].range_name]
  ip_range_services          = module.vpc.subnets_secondary_ranges[0][1].range_name
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names[0]
  project_id                 = var.project_id
  regional                   = true
  region                     = var.region
  zones                      = local.gke_cluster_zones
  service_account            = google_service_account.k8s.email
  remove_default_node_pool   = true
  create_service_account     = false
  default_max_pods_per_node  = 50
  enable_private_endpoint    = true
  enable_private_nodes       = true
  kubernetes_version         = var.k8s_version
  dns_allow_external_traffic = true
  release_channel            = var.release_channel
  maintenance_recurrence     = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH,FR,SA,SU"
  maintenance_end_time       = "1970-01-01T09:00:00Z"
  maintenance_start_time     = "1970-01-01T05:00:00Z"
  cluster_resource_labels = {
    "env"        = var.environment,
    "team"       = var.team,
    "automation" = "terraform",
  }
  enable_vertical_pod_autoscaling = true
  horizontal_pod_autoscaling      = true

  node_pools = [
    {
      name               = "${var.environment}-${var.region}-nodepool-1"
      machine_type       = var.machine_type
      node_locations     = join(",", var.nodepool_azs)
      min_count          = var.min_node_count
      max_count          = var.max_node_count
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      logging_variant    = "DEFAULT"
      service_account    = google_service_account.k8s.email
      preemptible        = false
      initial_node_count = var.min_node_count
      spot               = false
      autoscaling        = true
      version            = var.k8s_version
      strategy           = "BLUE_GREEN"
      max_surge          = 1
      max_unavailable    = 0
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  node_pools_labels = {
    all = {}

    "${var.environment}-${var.region}-nodepool-1" = {
      default-node-pool = true
    }
  }
  node_pools_tags = {
    all = []
  }
}

resource "google_container_node_pool" "spot_node_pools" {
  provider = google-beta.spot

  for_each = var.extra_node_pools

  name               = each.value.name
  cluster            = module.gke.cluster_id
  initial_node_count = each.value.initial_node_count
  location           = var.region

  node_config {
    spot            = each.value.spot
    machine_type    = each.value.machine_type
    service_account = google_service_account.k8s.email
    disk_size_gb    = each.value.disk_size_gb
    disk_type       = "pd-standard"
    image_type      = "COS_CONTAINERD"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }

  management {
    auto_repair  = each.value.auto_repair
    auto_upgrade = each.value.auto_upgrade
  }

  upgrade_settings {
    strategy        = "BLUE_GREEN"
    max_surge       = 1
    max_unavailable = 0
  }
}
