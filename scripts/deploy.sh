#!/bin/bash
# Zero-Downtime Deployment Script for StatusPulse
set -e

NEW_TAG=$1
if [ -z "$NEW_TAG" ]; then
    echo "Usage: ./deploy.sh <image_tag>"
    exit 1
fi

LOG_FILE="./deploy.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "[$(date +'%Y-%m-%d %H:%M:%S')] Starting deployment for tag: $NEW_TAG"

# 1. Pull the latest image
docker pull ghcr.io/${GITHUB_REPOSITORY,,}:$NEW_TAG

# 2. Start the new container with a temporary name/port
# Note: In a real production with Docker Compose, we might use 'docker compose up -d --no-deps --scale app=2'
# But for this assessment's simplicity, we will do a blue-green swap at the container level.

# Detect the network name (it might have a prefix like statuspulse_ depending on the directory)
NETWORK_NAME=$(docker network ls --format "{{.Name}}" | grep "statuspulse-network" | head -n 1)

if [ -z "$NETWORK_NAME" ]; then
    echo "Error: statuspulse-network not found. Ensure the stack is running."
    exit 1
fi

OLD_CONTAINER=$(docker ps -q --filter "name=statuspulse-app")

echo "Cleaning up any old deployment attempts..."
docker rm -f "statuspulse-app-new" || true

echo "Starting new container in network: $NETWORK_NAME..."
docker run -d \
    --name "statuspulse-app-new" \
    --network "$NETWORK_NAME" \
    --env-file .env \
    ghcr.io/${GITHUB_REPOSITORY,,}:$NEW_TAG

# 3. Health Check
echo "Checking health of new container..."
MAX_RETRIES=5
COUNT=0
HEALTHY=false

until [ $COUNT -eq $MAX_RETRIES ]; do
    if docker exec "statuspulse-app-new" curl -sf http://localhost:8000/health | grep -q '"status":"healthy"'; then
        HEALTHY=true
        break
    fi
    echo "Waiting for health check..."
    sleep 5
    COUNT=$((COUNT + 1))
done

if [ "$HEALTHY" = true ]; then
    echo "New container is healthy. Swapping..."
    if [ ! -z "$OLD_CONTAINER" ]; then
        docker stop statuspulse-app || true
        docker rm statuspulse-app || true
    fi
    docker rename "statuspulse-app-new" statuspulse-app
    echo "Deployment successful!"
else
    echo "New container failed health check. Rolling back..."
    docker stop "statuspulse-app-new" || true
    docker rm "statuspulse-app-new" || true
    exit 1
fi
