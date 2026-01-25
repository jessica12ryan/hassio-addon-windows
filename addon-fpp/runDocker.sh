# -----------------------------------
# -- FPP Add-on for Home Assistant --
# -----------------------------------
# ---------- runDocker.sh -----------

#!/bin/bash
# HA-friendly FPP entrypoint
# ---------------------------------

FPP_DIR="/opt/fpp"
CONFIG_DIR="/home/fpp/media"

echo "Starting FPP..."

# Ensure persistent directories exist
mkdir -p "$CONFIG_DIR"

# Build FPP init if missing
if [ ! -f "$FPP_DIR/src/fppinit" ]; then
    echo "fppinit missing, attempting build..."
    cd "$FPP_DIR/build" || mkdir -p "$FPP_DIR/build" && cd "$FPP_DIR/build"
    cmake .. && make -j$(nproc)
fi

# Run FPP init
if [ -f "$FPP_DIR/src/fppinit" ]; then
    "$FPP_DIR/src/fppinit" start
else
    echo "ERROR: fppinit not found!"
fi

# Keep container alive
tail -f /dev/null
