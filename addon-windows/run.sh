#!/bin/bash

echo "[Info] Starting Nginx for Ingress..."
nginx -g "daemon off;" &

echo "[Info] Patching environment..."
export STORAGE="/config/windows_data"
mkdir -p "$STORAGE"

# This replaces 'return' with 'exit' just in case
sed -i 's/return/exit/g' /run/start.sh

echo "[Info] Handing over control to Windows Engine..."
# 'exec' replaces our script with theirs, making it the primary process (PID 1)
exec /run/start.sh
