#!/bin/bash
set -e

# --- Configuration ---
export VERSION="tiny11"
export RAM_SIZE="4G"
export CPU_CORES="2"
export DISK_SIZE="32G"
export STORAGE="/config/windows_data"

echo "[Info] Ensuring storage directory exists at $STORAGE"
mkdir -p "$STORAGE"

# --- Start Services ---

echo "[Info] Starting Windows VM in background..."

# FIX: The actual path in the dockur/windows image is /run/start.sh
if [ -f /run/start.sh ]; then
    /run/start.sh &
else
    echo "[Error] Could not find /run/start.sh. Checking alternative paths..."
    # Fallback to search if the path changed in a newer version
    $(find / -name "start.sh" -executable -print -quit) &
fi

echo "[Info] Starting noVNC proxy on port 6080..."

# Wait for the VNC server (port 5900) to be ready
# Note: Using '127.0.0.1' is often more reliable than 'localhost' in Docker
until nc -z 127.0.0.1 5900; do
  echo "[Wait] Waiting for Windows VNC server to start (this can take 5+ mins)..."
  sleep 5
done

echo "[Info] VNC Server detected! Starting proxy..."
/opt/novnc/utils/novnc_proxy --vnc 127.0.0.1:5900 --listen 6080 &

echo "[Info] Starting Nginx for Ingress..."
nginx -g "daemon off;"
