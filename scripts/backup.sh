#!/bin/bash
# Backup Script for StatusPulse PostgreSQL
set -e

# Load environment variables if .env exists
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

BACKUP_DIR="/home/ubuntu/backups"
TIMESTAMP=$(date +'%Y-%m-%d_%H%M%S')
FILENAME="statuspulse_db_${TIMESTAMP}.sql.gz"
LOG_FILE="/var/log/statuspulse-backup.log"

log_msg() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

mkdir -p "$BACKUP_DIR"

log_msg "Starting database backup..."

# 1. Dump PostgreSQL
docker exec statuspulse-db pg_dump -U statuspulse statuspulse | gzip > "${BACKUP_DIR}/${FILENAME}"

log_msg "Backup created: ${FILENAME}"

# 2. Rotate backups (Keep last 7)
log_msg "Cleaning up old backups..."
find "$BACKUP_DIR" -name "statuspulse_db_*.sql.gz" -mtime +7 -delete

# 3. Optional S3 Upload
if [ ! -z "$S3_BUCKET" ]; then
    log_msg "Uploading backup to S3 bucket: ${S3_BUCKET}..."
    if aws s3 cp "${BACKUP_DIR}/${FILENAME}" "s3://${S3_BUCKET}/"; then
        log_msg "S3 upload successful."
    else
        log_msg "ERROR: S3 upload failed."
        exit 1
    fi
fi

log_msg "Backup process completed."
