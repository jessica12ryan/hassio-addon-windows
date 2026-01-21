#!/bin/bash
set -e

echo "Listing /home/fpp..."
ls -la /home/fpp

echo "Searching for FPP binary..."
find /home/fpp -name fpp -type f

# exit so the addon doesn't try to start yet
exit 0
