#!/bin/bash
set -e

echo "------------------------------"
echo "Running FPPINIT start"

# Fix Apache warning
if ! grep -q "ServerName" /etc/apache2/apache2.conf; then
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
fi

# Locate fppinit binary dynamically
FPP_INIT=$(find /home/fpp -name fppinit -type f | head -n1)

if [ -x "$FPP_INIT" ]; then
    "$FPP_INIT" 2>&1 | grep -v "cannot create directory '/run/php'" | grep -v "AH00558"
else
    echo "⚠ FPP init binary not found! Check the image."
fi

echo "------------------------------"
echo "FPP is ready!"
