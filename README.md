# 🏠 Homelab Cloud Infrastructure

This repository contains OpenTofu/Terraform modules for managing cloud infrastructure components of my homelab setup.

## 🌟 Features

- **Multi-Cloud Architecture**: Leveraging both Azure and GCP for different purposes
- **Infrastructure as Code**: All resources are managed through OpenTofu
- **Secure by Design**: Following cloud security best practices
- **Cost-Effective**: Storage optimized for the backup usage, using the free tier as much as possible 

## 📦 Modules

### 🚀 GCP Kubernetes Lab (`gcp/gke`)

GKE (Google Kubernetes Engine) cluster and VPC for running Kubernetes experiments and continues learning.

#### Features
- Regional GKE cluster with node autoscaling
- Custom VPC network with proper subnetting
- IAM roles and service accounts for infra services: external-secrets, external-dns and cert-manager
- Firewall rules
- Output variables for easy integration

#### Configuration Variables
| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| project_id | ID of the relevant GCP project | string | required |
| region | GCP region to use | string | "us-west1" |
| environment | Environment name | string | "dev" |
| team | Team responsible for resources | string | "devops" |
| cluster_name | Name of the GKE cluster | string | "homelab" |
| min_node_count | Min number of nodes per AZ in the default node pool | number | 0 |
| max_node_count | Max number of nodes per AZ in the default node pool | number | 1 |
| machine_type | Machine type for the default node pool nodes | string | "e2-micro" |
| vpc_name | Name of the VPC network | string | "homelab" |
| subnet_cidr | CIDR block for the subnet | string | "10.0.0.0/24" |
| k8s_version | Kubernetes version to deploy on GKE | string | "1.32" |
| release_channel | The release channel of the GKE cluster | string | "RAPID" |
| nodepool_azs | Availability Zones for default nodepool, autoscaling per AZ | list(string) | ["us-west1-a", "us-west1-b"] |
| extra_node_pools | Additional node pools configuration | map(object) | {} |

The `extra_node_pools` object supports the following attributes:
- name: Name of the node pool
- machine_type: Machine type for nodes
- initial_node_count: Initial number of nodes
- min_node_count: Minimum number of nodes
- max_node_count: Maximum number of nodes
- spot: Whether to use spot instances
- disk_size_gb: Size of the disk in GB
- auto_repair: Whether to enable auto repair
- auto_upgrade: Whether to enable auto upgrade

### 💾 Azure Offsite Backup (`azure/offsite-backup`)

A secure and cost-effective cloud backup solution for homelab data using Azure Storage.

#### Features
- Geo-redundant storage accounts
- Lifecycle management for cost optimization
- Secure access through SAS tokens and network configuration
- Backup versioning support

#### Configuration Variables
| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| storage_account_name | Name of the Storage Account | string | "offsitebackup" |
| location | Azure region | string | "northeurope" |
| resource_group_name | Name of Resource Group | string | "homelab" |
| tags | Resource tags | map(string) | {env = "homelab", owner = "admin"} |

## 🛠️ Prerequisites

- OpenTofu >= 1.6.0 ([Installation Guide](https://opentofu.org/docs/intro/install/))
- Azure CLI (for Azure modules)
- Google Cloud SDK (for GCP modules)
- Appropriate cloud provider credentials

## 🔐 Authentication

### Azure
```bash
az login
az account set --subscription "your-subscription-id"
```

### GCP
```bash
gcloud auth application-default login
```

## 🚀 Getting Started

1. Clone this repository
2. Navigate to the desired module directory
3. Initialize OpenTofu:
   ```bash
   tofu init
   ```
4. Review the planned changes:
   ```bash
   tofu plan
   ```
5. Apply the configuration:
   ```bash
   tofu apply
   ```

## 📝 License

MIT License - feel free to use this in your own homelab projects!

