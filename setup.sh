sudo -u zoneminder mkdir -p /home/zoneminder/storage/{data,events,images,logs,db-backups}

# Make backup/restore scripts executable
chmod +x /home/zoneminder/app/backup-db.sh
chmod +x /home/zoneminder/app/restore-db.sh
chmod +x /home/zoneminder/app/install-backup-cron.sh

# Install backup cron job
bash /home/zoneminder/app/install-backup-cron.sh