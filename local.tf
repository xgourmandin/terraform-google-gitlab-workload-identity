locals {

  sa_by_acc_id = {
    for sa in var.sa_accounts : sa.account_id => {
      display_name        = sa.display_name
      description         = sa.description
      gitlab_projects_ids = sa.gitlab_projects_ids
      project_principals = [
        for p in sa.gitlab_projects_ids :
        "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.default.name}/attribute.project_id/${p}"
      ]
      roles = sa.roles
    }
  }

  roles_and_accounts = {
    for id, role in flatten([
      for a, s in local.sa_by_acc_id : [for idx, r in s.roles : { "${a}${idx}" : { account_id : a, role : r } }]
    ]) : id => role
  }

  ressource_prefix = "${var.prefix != null ? "${var.prefix}-" : ""}gitlab"

  attribute_mapping = {
    "google.subject"           = "assertion.sub", # Required
    "attribute.aud"            = "assertion.aud",
    "attribute.project_path"   = "assertion.project_path",
    "attribute.project_id"     = "assertion.project_id",
    "attribute.namespace_id"   = "assertion.namespace_id",
    "attribute.namespace_path" = "assertion.namespace_path",
    "attribute.user_email"     = "assertion.user_email",
    "attribute.ref"            = "assertion.ref",
    "attribute.ref_type"       = "assertion.ref_type",
  }

  enabled_services = concat(["iamcredentials.googleapis.com"], var.extra_enabled_services)
}
