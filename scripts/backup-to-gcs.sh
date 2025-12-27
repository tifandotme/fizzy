#!/bin/bash
set -e

# Configuration
LOCAL_STORAGE="/home/eddies/fizzy-storage"
GCS_BUCKET="${GCS_BUCKET:-gs://fizzy-backups-neo-fizzy}"
DATE=$(date +%Y%m%d-%H%M%S)
LOG_FILE="/home/eddies/.logs/fizzy-backup.log"
GCP_KEY_FILE="/home/eddies/.gcp/fizzy-backup-key.json"

mkdir -p "$(dirname "$LOG_FILE")"

{
  echo "=== Backup started: $DATE ==="

  # Check if GCP key file exists
  if [ ! -f "$GCP_KEY_FILE" ]; then
    echo "ERROR: GCP key file not found at $GCP_KEY_FILE"
    echo "Please run: gsutil config set project YOUR_PROJECT_ID"
    echo "And download service account key to $GCP_KEY_FILE"
    exit 1
  fi

  # Activate service account
  gcloud auth activate-service-account --key-file="$GCP_KEY_FILE" 2>/dev/null || true

  # Check if local storage exists
  if [ ! -d "$LOCAL_STORAGE" ]; then
    echo "ERROR: Local storage directory not found at $LOCAL_STORAGE"
    exit 1
  fi

  # Sync to GCS (creates timestamped folder)
  # Exclude WAL files as they're recreated on restore
  echo "Syncing to $GCS_BUCKET/$DATE ..."
  gsutil -m rsync -r -d \
    -x ".*\.sqlite3-shm$|.*\.sqlite3-wal$" \
    "$LOCAL_STORAGE" "$GCS_BUCKET/$DATE"

  echo "✓ Backup completed successfully"
  echo "Backup location: $GCS_BUCKET/$DATE"
  echo "Local size: $(du -sh "$LOCAL_STORAGE" | cut -f1)"

} >>"$LOG_FILE" 2>&1

exit 0
