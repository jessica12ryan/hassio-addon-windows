#!/bin/bash
set -e

OPTIONS_FILE="/data/options.json"

if [ -f "$OPTIONS_FILE" ]; then
  export KVM=$(grep -oP '"KVM"\s*:\s*"\K[^"]+' "$OPTIONS_FILE")
  export DISK_SIZE=$(grep -oP '"DISK_SIZE"\s*:\s*"\K[^"]+' "$OPTIONS_FILE")
  export VERSION=$(grep -oP '"VERSION"\s*:\s*"\K[^"]+' "$OPTIONS_FILE")
  export LANGUAGE=$(grep -oP '"LANGUAGE"\s*:\s*"\K[^"]+' "$OPTIONS_FILE")
fi

echo "=== Home Assistant Options ==="
echo "KVM=${KVM}"
echo "DISK_SIZE=${DISK_SIZE}"
echo "VERSION=${VERSION}"
echo "LANGUAGE=${LANGUAGE}"
echo "=============================="

# IMPORTANT: exec original dockur entrypoint
exec /usr/bin/tini -s -- /run
