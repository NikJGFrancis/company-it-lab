#!/bin/bash
# ============================================
# Company IT Lab - Automated Backup Script
# Author: IT Admin
# Schedule: Daily via cron at 2:00 AM
# ============================================

# --- Configuration ---
BACKUP_SOURCE="/company/shared"
BACKUP_DEST="/var/backups/company"
REMOTE_USER="jake"
REMOTE_HOST="10.0.0.20"
REMOTE_PATH="/var/backups/remote_company"
LOG_FILE="/var/log/company_backup.log"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="company_backup_$DATE"
RETENTION_DAYS=7

# --- Colors ---
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" | tee -a "$LOG_FILE"
}

log "=============================="
log "Backup started: $BACKUP_NAME"
log "=============================="

# --- Step 1: Create compressed local backup ---
log "[1/4] Creating local compressed backup..."
tar -czf "$BACKUP_DEST/${BACKUP_NAME}.tar.gz" "$BACKUP_SOURCE" 2>> "$LOG_FILE"

if [[ $? -eq 0 ]]; then
    SIZE=$(du -sh "$BACKUP_DEST/${BACKUP_NAME}.tar.gz" | cut -f1)
    log "[OK] Local backup created. Size: $SIZE"
else
    log "[ERROR] Local backup FAILED!"
    exit 1
fi

# --- Step 2: Sync to remote server (VM2) ---
log "[2/4] Syncing to remote server ($REMOTE_HOST)..."
rsync -avz --progress \
    "$BACKUP_DEST/${BACKUP_NAME}.tar.gz" \
    "$REMOTE_USER@$REMOTE_HOST:$REMOTE_PATH/" \
    >> "$LOG_FILE" 2>&1

if [[ $? -eq 0 ]]; then
    log "[OK] Remote sync successful to $REMOTE_HOST"
else
    log "[WARNING] Remote sync failed. Local backup still exists."
fi

# --- Step 3: Verify backup integrity ---
log "[3/4] Verifying backup integrity..."
tar -tzf "$BACKUP_DEST/${BACKUP_NAME}.tar.gz" > /dev/null 2>&1
if [[ $? -eq 0 ]]; then
    log "[OK] Backup integrity verified - archive is valid."
else
    log "[ERROR] Backup is CORRUPT!"
fi

# --- Step 4: Clean up old backups ---
log "[4/4] Removing backups older than $RETENTION_DAYS days..."
find "$BACKUP_DEST" -name "*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;
log "[OK] Cleanup done. Current backups:"
ls -lh "$BACKUP_DEST" >> "$LOG_FILE"

log "=============================="
log "Backup completed successfully."
log "=============================="
