#!/bin/bash
set -e

# Use HA option if set, default to /config/fpp
FPP_DATA="${FPP_DATA_PATH:-/config/fpp}"

echo "🔧 Preparing persistent FPP storage at $FPP_DATA ..."

# Create persistent folder if it doesn't exist
mkdir -p "$FPP_DATA"

# Fix permissions
chown -R fpp:fpp "$FPP_DATA"
chmod -R 777 "$FPP_DATA"

# Ensure media points to persistent folder
rm -rf /home/fpp/media
ln -s "$FPP_DATA" /home/fpp/media

# Check for FPP binary installed by image
if [ -x "/home/fpp/FPP_Install.sh" ]; then
    echo "ℹ Running installer to place FPP binary..."
    cd /home/fpp
    chmod +x FPP_Install.sh
    ./FPP_Install.sh
fi

# Find the binary
FPP_BIN=$(find /home/fpp -name fpp -type f | head -n1)
if [ ! -x "$FPP_BIN" ]; then
    echo "❌ ERROR: FPP binary not found after installation!"
    exit 1
fi

echo "🚀 Starting Falcon Player at $FPP_BIN with data folder $FPP_DATA ..."
exec "$FPP_BIN" --data "$FPP_DATA"
