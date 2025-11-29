#!/bin/bash
# Backup ZoneMinder database

BACKUP_DIR="/home/zoneminder/storage/db-backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/zoneminder_$TIMESTAMP.sql"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Export database from container
docker exec app-zoneminder-1 mysqldump -u zmuser -pzmpass zm > "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✓ Database backed up to: $BACKUP_FILE"
    
    # Keep only last 7 backups
    ls -t "$BACKUP_DIR"/zoneminder_*.sql | tail -n +8 | xargs -r rm
    echo "✓ Old backups cleaned up (keeping last 7)"
else
    echo "✗ Backup failed!"
    exit 1
fi
