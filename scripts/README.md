# StatusPulse Management Scripts

Utility scripts for server maintenance, deployment, and monitoring.

## 🛠 Deployment & Hardening

### `harden-server.sh`
Configures the initial server environment:
- Updates packages and installs Docker.
- Hardens SSH (disables root/password login).
- Sets up UFW firewall (22, 80, 443).
- Configures Swap space for low-RAM instances.

### `deploy.sh`
Performs a **Zero-Downtime Blue-Green Deployment**:
1. Pulls the new image from GHCR.
2. Starts a "New" container.
3. Performs a health check against the new container.
4. If healthy: Swaps the old container with the new one.
5. If unhealthy: Automatically rolls back and keeps the old container running.

---

## 📊 Monitoring & Automation (Cron)

Schedule these via `crontab -e`:

### `health-monitor.sh`
- **Schedule**: `*/5 * * * *`
- **Actions**: Checks API health, disk usage (>80%), memory usage (>90%), and container status.
- **Alerts**: Sends instant notifications via `$ALERT_WEBHOOK_URL`.

### `update-dns.sh`
- **Schedule**: `*/5 * * * *`
- **Actions**: Syncs public IP with DuckDNS domain.

### `backup.sh`
- **Schedule**: `0 0 * * *` (Daily at Midnight)
- **Actions**: Creates a compressed `pg_dump`, rotates old backups (keeps 7 days), and optionally uploads to S3.

---

## 📝 Logging
- Deployment logs: `./deploy.log`
- System logs: `/var/log/statuspulse-*.log`
