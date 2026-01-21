#!/bin/bash
set -e

# Optional: Silence Apache warning
if ! grep -q "ServerName" /etc/apache2/apache2.conf; then
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
fi

echo "🔧 Preparing persistent FPP storage (bind mount)"

# Ensure HA persistent storage exists
mkdir -p /data

# Ensure target exists
mkdir -p /home/fpp/media

# Mount /data over FPP media directory
mountpoint -q /home/fpp/media || mount --bind /data /home/fpp/media

# Permissions for FPP user
chown -R fpp:fpp /data
chmod -R 755 /data

echo "✅ /data bind-mounted to /home/fpp/media"
echo "🚀 Starting Falcon Player"

exec /opt/fpp/fpp
