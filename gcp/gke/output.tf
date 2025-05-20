output "vpc_id" {
  description = "VPC Network ID"
  value       = module.vpc.network_id
}

output "cluster_id" {
  description = "Cluster ID"
  value       = module.gke.cluster_id
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
  depends_on = [
    module.gke
  ]
}

output "cluster_location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.gke.location
}

output "cluster_endpoint" {
  description = "Cluster's HTTPS endpoint"
  value       = module.gke.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Cluster's CA certificate"
  value       = module.gke.ca_certificate
  sensitive   = true
}
