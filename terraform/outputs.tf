output "bucket_name" {
  description = "Name of the GCS bucket for backups"
  value       = google_storage_bucket.fizzy_backups.name
}

output "bucket_url" {
  description = "GCS bucket URL"
  value       = "gs://${google_storage_bucket.fizzy_backups.name}"
}

output "service_account_email" {
  description = "Email of the backup service account"
  value       = google_service_account.fizzy_backup.email
}

output "key_file_path" {
  description = "Path to the downloaded service account key"
  value       = local_file.fizzy_backup_key_json.filename
}

output "backup_command" {
  description = "Example gsutil command to list backups"
  value       = "gsutil ls -r gs://${google_storage_bucket.fizzy_backups.name}/"
}

output "recovery_command" {
  description = "Example command to restore from backup"
  value       = "gsutil -m cp -r gs://${google_storage_bucket.fizzy_backups.name}/BACKUP_DATE/* /home/eddies/fizzy-storage/"
}
