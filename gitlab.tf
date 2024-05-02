locals {
  pref                  = var.prefix != null ? "_${var.prefix}" : ""
  gitlab_projects_ids   = flatten([for sa in var.sa_accounts : sa.gitlab_projects_ids])
  sa_by_gitlab_projects = { for id, project in flatten([for a, s in local.sa_by_acc_id : [for idx, p in s.gitlab_projects_ids : { "${a}${idx}" : { account_id : a, project : p } }]]) : id => project }
}

resource "gitlab_project_variable" "workload_identity_provider" {
  for_each = toset(local.gitlab_projects_ids)
  key      = "workload_id_provider_id${local.pref}"
  project  = each.value
  value    = google_iam_workload_identity_pool_provider.default.name
}

resource "gitlab_project_variable" "sa_email" {
  for_each = local.sa_by_gitlab_projects
  key      = "${each.value.account_id}_email${local.pref}"
  project  = each.value.project
  value    = google_service_account.default[each.value.account_id].email
}

resource "gitlab_project_variable" "project_id" {
  for_each = toset(local.gitlab_projects_ids)
  key      = "gcp_project_id${local.pref}"
  project  = each.value
  value    = var.gcp_project_id
}