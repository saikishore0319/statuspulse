#!/bin/bash
set -e

# Configuration
API_URL=${1:-"https://statuspulse1.duckdns.org"}
MAX_RETRIES=10
RETRY_INTERVAL=3

echo "Starting integration tests against $API_URL..."

# 1. Wait for health check to be healthy
echo "Waiting for service to be healthy..."

count=0

until curl -fsS "$API_URL/health" | grep -q '"status":"healthy"'; do
    if [ $count -eq $MAX_RETRIES ]; then
        echo ""
        echo "Service did not become healthy in time."

        echo "Last health response:"
        curl -s "$API_URL/health" || true

        exit 1
    fi

    printf '.'

    sleep $RETRY_INTERVAL
    count=$((count + 1))
done

echo ""
echo "Service is healthy!"

# 2. Test GET /
echo "Testing Root endpoint..."

curl -fsS "$API_URL/" | grep -q "StatusPulse"

echo "Root endpoint OK."

# 3. Test POST /services
echo "Testing Add Service..."

SERVICE_JSON='{"name":"Google","url":"https://google.com"}'

response=$(curl -fsS \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$SERVICE_JSON" \
    "$API_URL/services")

echo "$response" | grep -q '"name":"Google"'

echo "Add Service OK."

# 4. Test GET /services
echo "Testing List Services..."

curl -fsS "$API_URL/services" | grep -q '"name":"Google"'

echo "List Services OK."

# 5. Test POST /incidents
echo "Testing Create Incident..."

INCIDENT_JSON='{"service_name":"Google","title":"Slow response","description":"Taking > 2s","severity":"minor"}'

response=$(curl -fsS \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$INCIDENT_JSON" \
    "$API_URL/incidents")

echo "$response" | grep -q '"status":"investigating"'

echo "Create Incident OK."

# 6. Test GET /incidents
echo "Testing List Incidents..."

curl -fsS "$API_URL/incidents" | grep -q '"service_name":"Google"'

echo "List Incidents OK."

# 7. Test Duplicate Service
echo "Testing Duplicate Service handling..."

status_code=$(curl -s \
    -o /dev/null \
    -w "%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -d "$SERVICE_JSON" \
    "$API_URL/services")

if [ "$status_code" -eq 409 ]; then
    echo "Duplicate Service correctly returns 409."
else
    echo "Expected 409 for duplicate service, got $status_code"
    exit 1
fi

echo "All integration tests passed successfully!"
exit 0