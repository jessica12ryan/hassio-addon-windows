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

# We use '.' (dot) to source the script instead of executing it directly.
# This often bypasses the 'return' error in these specific base images.
if [ -f /run/start.sh ]; then
    . /run/start.sh &
else
    echo "[Error] Could not find /run/start.sh."
    exit 1
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
