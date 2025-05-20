resource "google_service_account" "k8s" {
  project      = var.project_id
  account_id   = "${var.environment}-gke-sa"
  display_name = "GKE Service Account"
  description  = "Service account for GKE cluster"
}

resource "google_project_iam_member" "k8s" {
  for_each = toset(local.k8s_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.k8s.email}"
}

#cert-manager IAM

resource "google_service_account" "cert_manager_sa" {
  project      = var.project_id
  account_id   = "${var.environment}-cert-manager"
  display_name = "cert-manager"
  description  = "Service account for cert-manager"
}

resource "google_project_iam_member" "cert_manager_principal" {
  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.cert_manager_sa.email}"
}

resource "google_service_account_iam_binding" "cert_manager_binding" {
  service_account_id = google_service_account.cert_manager_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${module.gke.identity_namespace}[cert-manager/cert-manager]"
  ]
}

#external-dns IAM

resource "google_service_account" "external_dns" {
  project      = var.project_id
  account_id   = "${var.environment}-external-dns"
  display_name = "external-dns"
  description  = "Service account for external-dns"
}

resource "google_project_iam_member" "external_dns_principal" {
  project = var.project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external_dns.email}"
}

resource "google_service_account_iam_binding" "external_dns_binding" {
  service_account_id = google_service_account.external_dns.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${module.gke.identity_namespace}[external-dns/external-dns]"
  ]
}

#external-secrets IAM
resource "google_service_account" "external_secrets_sa" {
  project      = var.project_id
  account_id   = "${var.environment}-external-secrets"
  display_name = "external-secrets"
  description  = "Service account for external-secrets"
}

resource "google_project_iam_member" "external_secrets_principal" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.external_secrets_sa.email}"
}

resource "google_service_account_iam_binding" "external_secrets_binding" {
  service_account_id = google_service_account.external_secrets_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${module.gke.identity_namespace}[external-secrets/external-secrets]"
  ]
}
