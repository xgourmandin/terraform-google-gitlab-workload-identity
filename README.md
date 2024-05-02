# GCP Gitlab Workload Identity Provider connection module

This module allows you to create a GCP Workload Identity Provider pool and authorize a given set of gitlab projects on
some GCP Service accounts.

the most important variable to understand is `sa_accounts`:

```hcl
sa_accounts = [
  {
    account_id = "service_account_id" # the service account id on GCP
    display_name = "a display name for the service account"
    description = "a description for the service account"
    roles = ["roles/role1", "roles/role2"] # the roles to be assigned to the service account
    gitlab_projects_ids = ["gitlab_project_id1", "gitlab_project_id2"] # the gitlab project ids to be authorized to connect using this service account
  }
]
```