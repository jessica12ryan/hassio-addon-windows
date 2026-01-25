# -----------------------------------
# -- FPP Add-on for Home Assistant --
# -----------------------------------
# ---------- runDocker.sh -----------
# -----------------------------------

#!/bin/bash
set -e

# Ensure /config/fpp exists
mkdir -p /config/fpp

# Start FPP services
if [ -f /opt/fpp/src/fppinit ]; then
    /opt/fpp/src/fppinit start
fi

# Keep container running
tail -f /dev/null
