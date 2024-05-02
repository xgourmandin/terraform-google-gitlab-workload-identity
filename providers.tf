terraform {
  required_version = ">= 1.6.2"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.27.0"
    }
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 16.11.0"
    }
  }
}