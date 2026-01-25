#!/bin/bash
#
# HA-friendly FPP Docker entrypoint
# Runs as fpp user, persistent, no sudo
#

set -e

FPP_DIR="/opt/fpp"
CONFIG_DIR="/home/fpp/media"
PHPVER="8.4"

# Ensure persistent directories exist and are owned by fpp
mkdir -p "$CONFIG_DIR" "$CONFIG_DIR/logs" "$CONFIG_DIR/tmp"
chown -R fpp:fpp "$CONFIG_DIR"

# Fix PHP-FPM log permissions
PHP_LOG="/var/log/php${PHPVER}-fpm.log"
mkdir -p "$(dirname "$PHP_LOG")"
touch "$PHP_LOG"
chown fpp:fpp "$PHP_LOG"

# Configure Apache
APACHE_CONF="/etc/apache2/apache2.conf"
if ! grep -q "^ServerName" "$APACHE_CONF"; then
    echo "ServerName localhost" >> "$APACHE_CONF"
fi

# Make sure Apache can write logs
mkdir -p /var/log/apache2
chown -R fpp:fpp /var/log/apache2

# Start PHP-FPM
php-fpm${PHPVER} -F -R &

# Start Apache in foreground
apache2 -DFOREGROUND &

# Initialize FPP directories (fppinit)
$FPP_DIR/src/fppinit start

# Keep container alive with FPP daemon
$FPP_DIR/src/fppd -c "$CONFIG_DIR/fppd.cfg" -p "$CONFIG_DIR/fppd.pid"
