######################################################
# File: backup-erp.sh
# Version: 1.0
# Author: Janis Grüttmüller on 13.02.2025
# Description: script to create a current backup of 
# the ERP systems productive database
#
# change history:
# 13.02.2025 - initial version
######################################################

#!/bin/bash

# Database Credentials
DB_USER="root"
DB_PASSWORD=""
DB_NAME="erp_prod"
BACKUP_DIR="database/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${DB_NAME}_backup_$TIMESTAMP.sql"

# Create Backup Directory if not exists
mkdir -p "$BACKUP_DIR"

# Run mysqldump
echo "create backup..."
mysqldump -u "$DB_USER" -p "$DB_PASSWORD" "$DB_NAME" > "$BACKUP_FILE"

# Optional: Compress Backup
# gzip "$BACKUP_FILE"

echo "Backup saved as $BACKUP_FILE"