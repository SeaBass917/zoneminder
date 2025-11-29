#!/bin/bash
# Restore ZoneMinder database from backup

BACKUP_DIR="/home/zoneminder/storage/db-backups"

# Find the most recent backup or use provided file
if [ -n "$1" ]; then
    BACKUP_FILE="$1"
else
    BACKUP_FILE=$(ls -t "$BACKUP_DIR"/zoneminder_*.sql 2>/dev/null | head -n 1)
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "✗ No backup file found!"
    echo "Usage: $0 [backup_file.sql]"
    echo "Available backups:"
    ls -lh "$BACKUP_DIR"/zoneminder_*.sql 2>/dev/null || echo "  (none)"
    exit 1
fi

echo "Restoring from: $BACKUP_FILE"
read -p "This will overwrite the current database. Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

# Import database into container
docker exec -i app-zoneminder-1 mysql -u zmuser -pzmpass zm < "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✓ Database restored successfully!"
    echo "✓ Restarting ZoneMinder container..."
    docker restart app-zoneminder-1
else
    echo "✗ Restore failed!"
    exit 1
fi
