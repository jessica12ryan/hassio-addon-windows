#!/bin/bash
set -e

# --- Configuration ---
# These env vars are used by the dockur/windows /start.sh script
export VERSION="tiny11"      # Using 'tiny11' is much faster for Home Assistant
export RAM_SIZE="4G"         # Adjust based on your host hardware
export CPU_CORES="2"
export DISK_SIZE="32G"
export STORAGE="/config/windows_data"

echo "[Info] Ensuring storage directory exists at $STORAGE"
mkdir -p "$STORAGE"

# --- Start Services ---

echo "[Info] Starting Windows VM in background..."
# We run the original entrypoint in the background
/start.sh &

echo "[Info] Starting noVNC proxy on port 6080..."
# Wait for the VNC server (port 5900) to be ready before proxying
until nc -z localhost 5900; do
  echo "[Wait] Waiting for Windows VNC server to start..."
  sleep 2
done

/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

echo "[Info] Starting Nginx for Ingress..."
nginx -g "daemon off;"
