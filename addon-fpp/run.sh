#!/bin/bash
set -e

echo "------------------------------"
echo "Running FPPINIT start"

# Fix Apache warning about ServerName
if ! grep -q "ServerName" /etc/apache2/apache2.conf; then
    echo "ServerName localhost" >> /etc/apache2/apache2.conf
fi

# Run FPP init while filtering known harmless warnings
FPP_INIT="/opt/fpp/fppinit"
if [ -x "$FPP_INIT" ]; then
    "$FPP_INIT" 2>&1 | grep -v "cannot create directory '/run/php'" | grep -v "AH00558"
else
    echo "⚠ FPP init binary not found at $FPP_INIT"
fi

echo "------------------------------"
echo "FPP is ready!"
