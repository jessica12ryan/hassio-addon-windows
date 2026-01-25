# -----------------------------------
# -- FPP Add-on for Home Assistant --
# -----------------------------------
# ---------- runDocker.sh -----------
# -----------------------------------

#!/bin/bash
# HA-friendly FPP run script

FPP_DIR="/opt/fpp"
CONFIG_DIR="/home/fpp/media"

mkdir -p "$CONFIG_DIR"

# Check fppinit exists
if [ ! -f "$FPP_DIR/src/fppinit" ]; then
    echo "ERROR: fppinit not found! Did FPP_Install.sh run correctly?"
    tail -f /dev/null
    exit 1
fi

# Start FPP
"$FPP_DIR/src/fppinit" start

# Keep container alive
tail -f /dev/null
