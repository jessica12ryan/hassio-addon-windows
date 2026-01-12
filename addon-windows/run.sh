#!/bin/bash

# Ensure we use the exact version name the script expects
export VERSION="tiny11"
export RAM_SIZE="4G"
export STORAGE="/config/windows_data"

mkdir -p "$STORAGE"

echo "[Info] Starting Windows VM..."

# Launch the internal script and log everything to a file
# This way, if it hangs, you can read /config/windows_data/boot.log
/run/start.sh > /config/windows_data/boot.log 2>&1 &

# Show the log in the HA console so you can see the download progress
tail -f /config/windows_data/boot.log &

# Wait for the VNC port (5900) to open
while ! (echo > /dev/tcp/127.0.0.1/5900) >/dev/null 2>&1; do
  echo "[Wait] Windows is initializing. Check the logs above for download status..."
  sleep 30
done

echo "[Success] Windows is ready!"
nginx -g "daemon off;"
