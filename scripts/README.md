# StatusPulse Management Scripts

This directory contains utility scripts for server maintenance, deployment, and monitoring.

## 🛠 Provisioning & Deployment

### `harden-server.sh`
**Usage**: `sudo ./harden-server.sh`  
**What it does**:
- Updates system packages.
- Creates a dedicated `deploy` user.
- Hardens SSH (disables root and password login).
- Configures UFW firewall (allows 22, 80, 443).
- Installs Docker and Docker Compose.
- Configures a 2GB swap file.

### `deploy.sh`
**Usage**: `./deploy.sh <image_tag>`  
**What it does**:
- Performs a zero-downtime (Blue-Green) deployment.
- Pulls the new image from GHCR.
- Starts a new container and waits for a healthy `/health` response.
- Swaps the containers and removes the old version.
- Automatically rolls back if the new version is unhealthy.

---

## 📊 Monitoring & Automation

### `health-monitor.sh`
**Usage**: Schedule via Cron (`*/5 * * * *`)  
**What it does**:
- Checks the local API `/health` endpoint.
- Monitors disk usage (>80%) and memory usage (>90%).
- Verifies that all 4 Docker containers are running (including Uptime Kuma).
- **TLS Monitoring**: Checks if your SSL certificate expires within 14 days and sends an alert.
- Sends alerts via a Discord/Slack Webhook if `ALERT_WEBHOOK_URL` is set.

### `update-dns.sh`
**Usage**: Schedule via Cron (`*/5 * * * *`)  
**What it does**:
- Syncs the server's current public IP with your DuckDNS domain.
- Requires `DUCKDNS_DOMAIN` and `DUCKDNS_TOKEN` in the environment.

### `backup.sh`
**Usage**: Schedule via Cron (`0 0 * * *`)  
**What it does**:
- Performs a `pg_dump` of the production database.
- Compresses the dump and saves it with a timestamp.
- **Rotation**: Keeps only the last 7 days of backups to save space.

---

## 📝 Logging
All scripts log their activity to `/var/log/statuspulse-*.log`.
