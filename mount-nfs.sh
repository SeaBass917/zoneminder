#!/bin/bash
# Ensure the internal container directories exist
mkdir -p /var/cache/zoneminder/events
mkdir -p /var/cache/zoneminder/images

# Execute the NFSv3 mounts from INSIDE the .202 isolated container space
mount -t nfs -o vers=3,nolock 192.168.1.151:/mnt/path/zoneminder/events /var/cache/zoneminder/events
mount -t nfs -o vers=3,nolock 192.168.1.151:/mnt/path/zoneminder/images /var/cache/zoneminder/images