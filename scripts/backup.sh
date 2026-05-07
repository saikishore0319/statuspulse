#!/bin/bash
# Backup Script for StatusPulse PostgreSQL
set -e

BACKUP_DIR="/home/deploy/backups"
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

# 3. Optional S3 Upload (Placeholder)
# if [ ! -z "$S3_BUCKET" ]; then
#     aws s3 cp "${BACKUP_DIR}/${FILENAME}" "s3://${S3_BUCKET}/"
# fi

log_msg "Backup process completed."
