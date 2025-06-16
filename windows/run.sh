#!/bin/sh

/start.sh &

/opt/novnc/utils/novnc_proxy --vnc localhost:5900 --listen 6080 &

nginx -g "daemon off;"
