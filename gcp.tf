resource "google_project_service" "default" {
  for_each = toset(local.enabled_services)
  service  = each.value
  project  = var.gcp_project_id
}
