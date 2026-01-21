#!/bin/bash
# run.sh - Start Falcon Player with persistent HA folder

# Default persistent folder
FPP_DATA="${FPP_DATA_PATH:-/config/fpp}"

# Create persistent folder if it doesn't exist
if [ ! -d "$FPP_DATA" ]; then
  echo "Creating persistent folder at $FPP_DATA"
  mkdir -p "$FPP_DATA"
fi

# Set permissions so FPP can write
chmod -R 777 "$FPP_DATA"

# Start FPP with persistent data folder
echo "Starting FPP with data folder: $FPP_DATA"
/opt/fpp/fpp --data "$FPP_DATA"
