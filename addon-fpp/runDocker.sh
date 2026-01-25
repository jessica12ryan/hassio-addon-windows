# -----------------------------------
# -- FPP Add-on for Home Assistant --
# -----------------------------------
# ---------- runDocker.sh -----------
# -----------------------------------

#!/bin/bash
set -e

# Ensure /run/php exists
mkdir -p /run/php

# Fix ownership of config and FPP folders
chown -R fpp:fpp /opt/fpp /home/fpp /config/fpp

# Start PHP-FPM
php-fpm8.4 -F &

# Start Apache
apache2ctl -D FOREGROUND
