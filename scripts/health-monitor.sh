#!/bin/bash
# Health Monitor Script for StatusPulse
set -e

ALERT_WEBHOOK_URL=${ALERT_WEBHOOK_URL:-""}
LOG_FILE="/var/log/statuspulse-monitor.log"
DOMAIN=${DOMAIN:-"statuspulse1.duckdns.org"} # Default domain for TLS check

log_msg() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

send_alert() {
    local msg=$1
    log_msg "ALERT: $msg"
    if [ ! -z "$ALERT_WEBHOOK_URL" ]; then
        curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"🚨 **StatusPulse Alert**: $msg\"}" "$ALERT_WEBHOOK_URL"
    fi
}

# 1. Check /health endpoint
if ! curl -sf http://localhost:8000/health | grep -q '"status":"healthy"'; then
    send_alert "Application health check failed!"
fi

# 2. Check Disk Usage (> 80%)
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
    send_alert "Disk usage is critical: ${DISK_USAGE}%"
fi

# 3. Check Memory Usage (> 90%)
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d. -f1)
if [ "$MEM_USAGE" -gt 90 ]; then
    send_alert "Memory usage is critical: ${MEM_USAGE}%"
fi

# 4. Check if containers are running
for container in statuspulse-app statuspulse-db statuspulse-redis statuspulse-uptime-kuma; do
    if ! docker ps --filter "name=$container" --filter "status=running" | grep -q "$container"; then
        send_alert "Container $container is not running!"
    fi
done

# 5. Check TLS Certificate Expiration (Task 4c requirement: < 14 days)
CERT_PATH="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"
if [ -f "$CERT_PATH" ]; then
    EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CERT_PATH" | cut -d= -f2)
    EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
    NOW_EPOCH=$(date +%s)
    DAYS_LEFT=$(( ($EXPIRY_EPOCH - $NOW_EPOCH) / 86400 ))

    if [ "$DAYS_LEFT" -lt 14 ]; then
        send_alert "TLS Certificate for ${DOMAIN} expires in ${DAYS_LEFT} days!"
    fi
fi

log_msg "Monitoring check completed successfully."
