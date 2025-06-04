resource "helm_release" "lab_external_secrets" {
  name             = "external-secrets"
  namespace        = "external-secrets"
  chart            = "${path.module}/infracharts/external-secrets"
  create_namespace = true

  values = [
    yamlencode({
      environment = var.environment
      projectID   = var.project_id
      clusterSecretStore = {
        clusterName        = module.gke.name
        clusterLocation    = var.region
        serviceAccountName = google_service_account.external_secrets_sa.name
      }
      "external-secrets" = {
        serviceAccount = {
          annotations = {
            "iam.gke.io/gcp-service-account" = "${google_service_account.external_secrets_sa.email}"
          }
        }
      }
    })
  ]

  depends_on = [module.gke]
} 