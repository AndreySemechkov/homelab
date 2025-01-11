variable "homelab_ip" {
  description = "The public IP address of the homelab"
  validation {
    condition = length(var.homelab_ip) > 0
    error_message = "The homelab IP address must be provided"
  }
}