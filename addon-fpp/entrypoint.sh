#!/bin/bash
set -e

echo "🔧 Preparing persistent FPP directories..."

# Create persistent directories
mkdir -p /data/media /data/config /data/logs

# Remove existing FPP directories if present
rm -rf /home/fpp/media
rm -rf /home/fpp/config
rm -rf /home/fpp/logs

# Symlink to HA persistent storage
ln -s /data/media /home/fpp/media
ln -s /data/config /home/fpp/config
ln -s /data/logs /home/fpp/logs

# Permissions (FPP runs as fpp user)
chown -R fpp:fpp /data
chmod -R 755 /data

echo "✅ Persistent storage linked"
echo "🚀 Starting Falcon Player..."

exec /opt/fpp/fpp
