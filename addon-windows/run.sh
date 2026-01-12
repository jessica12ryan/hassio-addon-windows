#!/bin/bash

# Configuration
export VERSION="tiny11"
export RAM_SIZE="4G"
export STORAGE="/config/windows_data"
mkdir -p "$STORAGE"

echo "[Info] Starting Windows VM ($VERSION)..."

# --- THE CRITICAL CHANGE ---
# Instead of running start.sh in the background where it's silent,
# we run it and pipe the output to a log file we can watch.
/run/start.sh > /config/windows_data/boot.log 2>&1 &

echo "[Info] Monitoring internal boot logs..."

# This 'tail' command will show you the ACTUAL download progress 
# and any errors in your Home Assistant console.
tail -f /config/windows_data/boot.log &

# Wait loop
while ! (echo > /dev/tcp/127.0.0.1/5900) >/dev/null 2>&1; do
  echo "[Wait] Still waiting for VNC... check the 'tail' output above for progress."
  
  # Check if Disk space is an issue
  DF_CHECK=$(df -h /config | tail -1 | awk '{print $4}')
  echo "[Debug] Free space left: $DF_CHECK"
  
  sleep 30
done

echo "[Success] Windows VNC is active!"
nginx -g "daemon off;"
