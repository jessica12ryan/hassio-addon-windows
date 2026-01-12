#!/bin/bash

echo "[Info] Starting Nginx for Ingress..."
nginx -g "daemon off;" &

echo "[Info] Configuring Environment for Emulation..."
export STORAGE="/config/windows_data"
export KVM="off"  # Force software emulation
export VERSION="tiny11"
export RAM_SIZE="4G"

mkdir -p "$STORAGE"

# Patch the internal script to prevent crashes
sed -i 's/return/exit/g' /run/start.sh

echo "[Warning] Running WITHOUT KVM. Startup will be very slow (30-60 mins)."
echo "[Info] Launching Windows Engine..."

# Run start.sh directly. Since KVM is off, it will use QEMU emulation.
/run/start.sh
