#!/usr/bin/with-contenv bash
set -e

# Read HA options
KVM=$(jq -r '.KVM' /data/options.json)
DISK_SIZE=$(jq -r '.DISK_SIZE' /data/options.json)
VERSION=$(jq -r '.VERSION' /data/options.json)
LANGUAGE=$(jq -r '.LANGUAGE' /data/options.json)

# Export as environment variables for dockur/windows
export KVM
export DISK_SIZE
export VERSION
export LANGUAGE

echo "Starting Windows VM"
echo "KVM=$KVM"
echo "DISK_SIZE=$DISK_SIZE"
echo "VERSION=$VERSION"
echo "LANGUAGE=$LANGUAGE"

# Start the original container entrypoint
exec /entrypoint.sh
