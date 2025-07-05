variable "project_id" {
  description = "ID of the relevant GCP project"
  type        = string
}

variable "region" {
  description = "GCP region to use"
  type        = string
  default     = "us-west1"
}

variable "environment" {
  type        = string
  description = "The environment name the resources are deployed to."
  default     = "dev"
}

variable "team" {
  type        = string
  description = "The team responsible for the resources"
  default     = "devops"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "homelab"
}

variable "min_node_count" {
  description = "Min number of nodes per AZ in the default node pool"
  type        = number
  default     = 0
}

variable "max_node_count" {
  description = "Max number of nodes per Az in the default node pool"
  type        = number
  default     = 1
}

variable "machine_type" {
  description = "Machine type for the default node pool nodes"
  type        = string
  default     = "e2-small"
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
  default     = "homelab"
}

variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "k8s_version" {
  description = "Kubernetes version to deploy on GKE"
  type        = string
  default     = "1.32"
}


variable "release_channel" {
  description = "The release channel of the GKE cluster"
  type        = string
  default     = "RAPID"
}


variable "nodepool_azs" {
  description = "Availability Zones for default nodepool, autoscaling per AZ"
  type        = list(any)
  default     = ["us-west1-a", "us-west1-b"]
}


variable "extra_node_pools" {
  description = "Additional node pools configuration"
  type = map(object({
    name               = string
    machine_type       = string
    initial_node_count = number
    min_node_count     = number
    max_node_count     = number
    spot               = bool
    disk_size_gb       = number
    auto_repair        = bool
    auto_upgrade       = bool
  }))
  default = {}
}

variable "enable_public_endpoint" {
  description = "Whether to enable the public endpoint for the GKE cluster, True for dev lab use , for production use false and authozired_networks"
  type        = bool
  default     = true
}
