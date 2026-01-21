#!/usr/bin/env bash
CONFIG="/data/options.json"

# Read user-configured options from HA addon UI
DISK_SIZE=$(jq -r '.DISK_SIZE // "16G"' $CONFIG)
VERSION=$(jq -r '.VERSION // "xp"' $CONFIG)
LANGUAGE=$(jq -r '.LANGUAGE // "English"' $CONFIG)

echo "Starting Windows container with:"
echo "DISK_SIZE=$DISK_SIZE"
echo "VERSION=$VERSION"
echo "LANGUAGE=$LANGUAGE"

# Pass these as environment variables to the original entrypoint
exec /entrypoint.sh
