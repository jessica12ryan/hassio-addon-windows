#!/bin/bash

# Configuration
export VERSION="tiny11"
export RAM_SIZE="4G"
export STORAGE="/config/windows_data"
mkdir -p "$STORAGE"

echo "[Info] Patching internal startup script..."
# This replaces 'return' with 'exit' in the internal script so it can run standalone
sed -i 's/return/exit/g' /run/start.sh

echo "[Info] Starting Windows VM ($VERSION)..."

# Run the script directly in the background
/run/start.sh > /config/windows_data/boot.log 2>&1 &

echo "[Info] Monitoring boot log for activity..."

# Wait loop with log scraping
while ! (echo > /dev/tcp/127.0.0.1/5900) >/dev/null 2>&1; do
  
  # Print the last 2 lines of the actual boot log so we see real errors
  LAST_LINE=$(tail -n 1 /config/windows_data/boot.log)
  echo "[Internal Log] $LAST_LINE"
  
  # Check for common download percentages
  PROGRESS=$(grep -o '[0-9]\{1,3\}%' /config/windows_data/boot.log | tail -1)
  if [ ! -z "$PROGRESS" ]; then
    echo "[Progress] Download is at $PROGRESS"
  fi

  sleep 15
done

echo "[Success] Windows VNC is active!"
nginx -g "daemon off;"
