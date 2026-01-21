#!/bin/bash
set -e

# Default persistent folder (HA option override)
FPP_DATA="${FPP_DATA_PATH:-/config/fpp}"

echo "🔧 Preparing persistent FPP storage at $FPP_DATA ..."

# Create persistent folder if it doesn't exist
mkdir -p "$FPP_DATA"

# Ensure proper permissions
chown -R fpp:fpp "$FPP_DATA"
chmod -R 777 "$FPP_DATA"

# Symlink /home/fpp/media to persistent folder
rm -rf /home/fpp/media
ln -s "$FPP_DATA" /home/fpp/media

# Locate the FPP binary
FPP_BIN=$(find /home/fpp -name fpp -type f | head -n1)

if [ ! -x "$FPP_BIN" ]; then
    echo "❌ ERROR: FPP binary not found!"
    exit 1
fi

echo "🚀 Starting Falcon Player at $FPP_BIN with data folder $FPP_DATA ..."
exec "$FPP_BIN" --data "$FPP_DATA"
