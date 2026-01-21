#!/usr/bin/env bash
set -e

# Path to FPP config
CONFIG_FILE="/config/fpp/fpp.json"

# Read port from addon option
FPP_PORT=${FPP_PORT:-80}

# Make sure config file exists
if [ -f "$CONFIG_FILE" ]; then
    echo "Updating FPP WebPort to $FPP_PORT"
    # Use jq to update the JSON safely
    if command -v jq >/dev/null 2>&1; then
        jq ".WebPort = $FPP_PORT" "$CONFIG_FILE" > "$CONFIG_FILE.tmp" && mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    else
        # fallback if jq is missing
        sed -i "s/\"WebPort\"[ ]*:[ ]*[0-9]*/\"WebPort\": $FPP_PORT/" "$CONFIG_FILE"
    fi
else
    echo "FPP config file not found at $CONFIG_FILE, skipping port update"
fi

# Start FPP normally
exec /usr/local/bin/fppd
