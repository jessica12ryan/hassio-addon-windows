#!/bin/bash

# Configuration
export VERSION=${version:-"tiny11"}
export RAM_SIZE=${ram_size:-"4G"}
export STORAGE="/config/windows_data"
mkdir -p "$STORAGE"

echo "[Info] Starting Windows VM ($VERSION)..."

# --- THE FIX ---
# We define a function to 'catch' the return call from start.sh 
# so it doesn't kill our whole run.sh script.
start_vm() {
    # 'source' (or .) runs the script inside this shell process
    source /run/start.sh
}

# Run the function in the background
start_vm &

echo "[Info] Monitoring startup..."

# Monitor port 5900 (Internal Windows VNC)
# We don't check for 'pgrep qemu' here because during ISO download, 
# qemu might not be active yet.
while ! (echo > /dev/tcp/127.0.0.1/5900) >/dev/null 2>&1; do
  echo "[Wait] Windows is preparing (Downloading ISO or creating Disk)..."
  sleep 20
done

echo "[Success] Windows VNC is active!"
nginx -g "daemon off;"
