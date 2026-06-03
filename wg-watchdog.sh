#!/bin/bash

# Configuration
TARGET="10.0.0.1"
INTERFACE="wg-infra"
LOGFILE="/var/log/wg-watchdog.log"

# Ping Test (3 attempts, max 5 seconds timeout)
if ! ping -c 3 -W 5 $TARGET > /dev/null 2>&1; then
    echo "$(date): Tunnel $INTERFACE is offline. Restarting service..." >> $LOGFILE
    systemctl restart wg-quick@$INTERFACE
fi
