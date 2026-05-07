#!/bin/bash
# DuckDNS Update Script for StatusPulse
set -e

# These should be set in your .env file or environment
DOMAIN=${DUCKDNS_DOMAIN:-""}
TOKEN=${DUCKDNS_TOKEN:-""}

if [ -z "$DOMAIN" ] || [ -z "$TOKEN" ]; then
    echo "DUCKDNS_DOMAIN or DUCKDNS_TOKEN not set. Skipping update."
    exit 0
fi

LOG_FILE="/var/log/statuspulse-dns.log"

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Updating DuckDNS for domain: $DOMAIN" | tee -a "$LOG_FILE"

RESPONSE=$(curl -s "https://www.duckdns.org/update?domains=${DOMAIN}&token=${TOKEN}&ip=")

if [ "$RESPONSE" = "OK" ]; then
    echo "DuckDNS update successful!" | tee -a "$LOG_FILE"
else
    echo "DuckDNS update failed. Response: $RESPONSE" | tee -a "$LOG_FILE"
    exit 1
fi
