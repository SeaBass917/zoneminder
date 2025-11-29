sudo -u zoneminder mkdir -p /home/zoneminder/storage/{data,events,images,logs,ssl,certbot,db-backups}

# Initial SSL certificate generation
CERT_PATH="/home/zoneminder/storage/ssl/live/$DOMAIN_NAME_zoneminder/fullchain.pem"
CERT_VALID=false

if [ -f "$CERT_PATH" ]; then
    echo "Checking existing SSL certificate..."
    # Check if certificate is valid and not expired
    if openssl x509 -checkend 86400 -noout -in "$CERT_PATH" 2>/dev/null; then
        echo "SSL certificate is valid, skipping certificate generation"
        CERT_VALID=true
    else
        echo "SSL certificate is invalid or expiring soon, will regenerate"
    fi
fi

if [ "$CERT_VALID" = false ]; then
    echo "Requesting SSL certificate..."
    if ! docker run --rm \
        -v /home/zoneminder/storage/ssl:/etc/letsencrypt \
        -v /home/zoneminder/storage/certbot:/var/www/certbot \
        -p 80:80 \
        certbot/certbot certonly --standalone \
        -d $DOMAIN_NAME_zoneminder \
        --email $LETSENCRYPT_EMAIL \
        --agree-tos \
        --non-interactive; then
        echo "Error: Certificate generation failed"
        exit 1
    fi
fi

# Make backup/restore scripts executable
chmod +x /home/zoneminder/app/backup-db.sh
chmod +x /home/zoneminder/app/restore-db.sh
chmod +x /home/zoneminder/app/install-backup-cron.sh

# Install backup cron job
bash /home/zoneminder/app/install-backup-cron.sh