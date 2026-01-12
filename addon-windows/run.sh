#!/bin/bash

# Configuration
export VERSION="tiny11"
export RAM_SIZE="4G"
export STORAGE="/config/windows_data"
mkdir -p "$STORAGE"

echo "[Info] Starting Windows VM ($VERSION)..."

# Function to handle the internal sourcing
launch_vm() {
    . /run/start.sh
}

# Run in background and capture logs
launch_vm > /config/windows_data/boot.log 2>&1 &

echo "[Info] Monitoring startup and download progress..."

# Wait for the log to actually be created
sleep 5

# This loop parses the boot.log for progress strings
while ! (echo > /dev/tcp/127.0.0.1/5900) >/dev/null 2>&1; do
  
  # Extract the last line containing a percentage (common for wget/curl)
  PROGRESS=$(grep -o '[0-9]\{1,3\}%' /config/windows_data/boot.log | tail -1)
  
  # Check for specific status messages
  if grep -q "Downloading" /config/windows_data/boot.log; then
    STATUS="Downloading ISO: ${PROGRESS:-0%}"
  elif grep -q "Extracting" /config/windows_data/boot.log; then
    STATUS="Extracting ISO image..."
  elif grep -q "Creating" /config/windows_data/boot.log; then
    STATUS="Creating Virtual Disk..."
  else
    STATUS="Initializing Windows Engine..."
  fi

  echo "[Progress] $STATUS"
  
  # Check if the process died
  if ! pgrep -f "qemu" > /dev/null && ! pgrep -f "wget" > /dev/null; then
     # After about 2 minutes, if nothing is running, it's a real crash
     if [ $(stat -c %Y /config/windows_data/boot.log) -lt $(( $(date +%s) - 60 )) ]; then
        echo "[Error] Startup process seems to have stalled. Checking last 5 lines of log:"
        tail -n 5 /config/windows_data/boot.log
        exit 1
     fi
  fi

  sleep 20
done

echo "[Success] Windows VNC is active on port 5900!"
echo "[Info] Starting Nginx proxy for Ingress..."
nginx -g "daemon off;"
