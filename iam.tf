resource "google_service_account" "default" {
  for_each     = local.sa_by_acc_id
  account_id   = each.key
  display_name = each.value.display_name
  description  = each.value.description
}

resource "google_service_account_iam_binding" "default" {
  for_each           = local.sa_by_acc_id
  members            = each.value.project_principals
  role               = "roles/iam.workloadIdentityUser"
  service_account_id = google_service_account.default[each.key].name
}

resource "google_project_iam_member" "default" {
  for_each = local.roles_and_accounts
  project  = var.gcp_project_id
  role     = each.value.role

  member = "serviceAccount:${google_service_account.default[each.value.account_id].email}"
}