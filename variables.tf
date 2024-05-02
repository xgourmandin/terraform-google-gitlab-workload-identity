variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID to connect to"
}


variable "extra_enabled_services" {
  description = "a list of extra services to enable on the project"
  default     = []
}

variable "prefix" {
  type        = string
  description = "Optional. A prefix for the names of all resources created by this module"
  default     = null
}

variable "sa_accounts" {
  type = list(object({
    account_id          = string
    display_name        = optional(string, "")
    description         = optional(string, "")
    roles               = optional(list(string), ["roles/editor"])
    gitlab_projects_ids = optional(list(string), [])
  }))
  description = "List of service accounts to create with their roles and the Gitlab projects that can connect to them"
}

variable "gitlab_url" {
  type        = string
  description = "Optional. A custom gitlab url for the configuration of on-premise instance"
  default     = "https://gitlab.com"

  validation {
    condition     = startswith(var.gitlab_url, "https://")
    error_message = "This module only works if the Gitlab instance is exposed with HTTPS."
  }
}