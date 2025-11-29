#!/bin/bash
# Install cron job for ZoneMinder database backups

# Add daily backup at 2 AM
CRON_JOB="0 2 * * * /home/zoneminder/app/backup-db.sh >> /home/zoneminder/storage/logs/backup.log 2>&1"

# Check if cron job already exists
if crontab -u zoneminder -l 2>/dev/null | grep -q "backup-db.sh"; then
    echo "Cron job already exists"
else
    # Add to zoneminder user's crontab
    (crontab -u zoneminder -l 2>/dev/null; echo "$CRON_JOB") | crontab -u zoneminder -
    echo "✓ Cron job added - Database will backup daily at 2 AM"
fi
