resource "random_id" "random" {
  byte_length = 4
}

resource "google_iam_workload_identity_pool" "default" {
  workload_identity_pool_id = substr("${local.ressource_prefix}-identity-pool-${random_id.random.hex}", 0, 32)
}

resource "google_iam_workload_identity_pool_provider" "default" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.default.workload_identity_pool_id
  workload_identity_pool_provider_id = substr("${local.ressource_prefix}-provider-${random_id.random.hex}", 0, 32)

  attribute_mapping = local.attribute_mapping

  oidc {
    issuer_uri        = var.gitlab_url
    allowed_audiences = [var.gitlab_url]
  }
}
