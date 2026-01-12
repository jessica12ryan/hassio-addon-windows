#!/bin/bash
set -e

# Configuration from environment or defaults
export VERSION=${version:-"tiny11"}
export RAM_SIZE=${ram_size:-"4G"}
export STORAGE="/config/windows_data"

echo "[Info] Ensuring storage directory exists at $STORAGE"
mkdir -p "$STORAGE"

echo "[Info] Starting Windows VM ($VERSION) with $RAM_SIZE RAM..."

# Start the Windows engine in the background
# We use 'bash' to run it to prevent 'return' errors from crashing the addon
bash /run/start.sh &

echo "[Info] Waiting for Windows to initialize..."

# Monitor port 5900 (The internal Windows VNC port)
# This loop will run until the VM is actually ready
while ! (echo > /dev/tcp/127.0.0.1/5900) >/dev/null 2>&1; do
  echo "[Wait] Windows is still booting or downloading ISO. This can take 10+ minutes..."
  
  # Check if the process died
  if ! pgrep -f "qemu" > /dev/null; then
    echo "[Error] The Windows process crashed. Check logs for KVM or RAM errors."
    exit 1
  fi
  
  sleep 10
done

echo "[Success] Windows VNC is active!"
echo "[Info] Starting Nginx Proxy for Ingress and Port 6080..."

nginx -g "daemon off;"
