#!/bin/bash

# Start the Windows VM in the background
# We use the original entrypoint script from the base image
/start.sh &

# Wait a few seconds for the VNC server to actually initialize
sleep 5

# Start the noVNC proxy
/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

# Start Nginx in the foreground (this keeps the container alive)
echo "Starting Nginx for Ingress..."
nginx -g "daemon off;"
