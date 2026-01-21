#!/bin/bash
set -e

# ------------------------------------------------------------
# FPP HA Add-on Entrypoint
# Fully persistent, fixes Apache warning, ready for HA
# ------------------------------------------------------------

# Optional: Silence Apache warning
if ! grep -q "ServerName" /etc/apache2/apache2.conf; then
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
    echo "✅ Apache ServerName set to localhost"
fi

# Prepare persistent FPP storage
echo "🔧 Preparing persistent FPP storage (bind mount)..."
mkdir -p /data
mkdir -p /home/fpp/media

if ! mountpoint -q /home/fpp/media; then
    mount --bind /data /home/fpp/media
    echo "✅ /data bind-mounted to /home/fpp/media"
else
    echo "ℹ /home/fpp/media already a mountpoint"
fi

chown -R fpp:fpp /data
chmod -R 755 /data

# -------------------------------
# Start Falcon Player
# -------------------------------
echo "🚀 Starting Falcon Player..."

# CORRECT BINARY PATH
exec /home/fpp/fpp
