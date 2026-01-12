#!/bin/bash

echo "[Info] Starting Nginx for Ingress..."
nginx -g "daemon off;" &

echo "[Info] Configuring Environment for Emulation..."
export STORAGE="/config/windows_data"
export KVM="off"              # Hardware acceleration disabled
export VERSION="tiny11"       # Lightweight Windows 11
export RAM_SIZE="4G"          # Minimum recommended for Tiny11
export CPU_CORES="2"          # Don't over-provision cores in emulation

# These flags help QEMU run slightly faster when emulating
export ARGUMENTS="-cpu qemu64,+ssse3,+sse4.1,+sse4.2 -vga std"

mkdir -p "$STORAGE"

# Patch the internal script to prevent crashes
sed -i 's/return/exit/g' /run/start.sh

echo "[Warning] Running WITHOUT KVM. This will be slow!"
echo "[Info] Handing over to Windows Engine..."

# Start the engine
/run/start.sh
