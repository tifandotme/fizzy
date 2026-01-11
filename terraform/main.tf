terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

locals {
  gcp_location   = "asia-southeast2"
  gcp_project_id = "neo-fizzy"
}

provider "google" {
  project = local.gcp_project_id
  region  = local.gcp_location
}

# GCS bucket for backups
resource "google_storage_bucket" "fizzy_backups" {
  name          = "fizzy-backups-${local.gcp_project_id}"
  location      = local.gcp_location
  force_destroy = false

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }
}

# Service account for backup agent
resource "google_service_account" "fizzy_backup" {
  account_id   = "fizzy-backup"
  display_name = "Fizzy backup agent"
}

# IAM binding: service account can read and write to bucket
resource "google_storage_bucket_iam_member" "fizzy_backup_writer" {
  bucket = google_storage_bucket.fizzy_backups.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.fizzy_backup.email}"
}

# Service account key (downloaded for server auth)
resource "google_service_account_key" "fizzy_backup_key" {
  service_account_id = google_service_account.fizzy_backup.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

# Output the key JSON for manual deployment
resource "local_file" "fizzy_backup_key_json" {
  content  = base64decode(google_service_account_key.fizzy_backup_key.private_key)
  filename = "${path.module}/fizzy-backup-key.json"

  provisioner "local-exec" {
    command = "chmod 600 ${path.module}/fizzy-backup-key.json"
  }
}
