#!/bin/bash

# Tell the Windows image to store the virtual disk in the persistent config folder
export VERSION="11" # Or "tiny11" for better performance
export DISK_SIZE="32G"
export STORAGE="/config/windows"

mkdir -p /config/windows

# Start the Windows VM
/start.sh &

sleep 5

# Start the noVNC proxy
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

nginx -g "daemon off;"
