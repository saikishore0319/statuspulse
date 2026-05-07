# Security Policy - StatusPulse

## Secret Management
- No secrets (passwords, keys, tokens) are committed to the repository.
- Use `.env` file for local development (excluded via `.gitignore`).
- Use GitHub Actions Secrets for CI/CD environment variables.
- Production secrets are managed on the server via a secured `.env` file with `600` permissions.

## Container Security
- **Multi-stage builds**: Used to minimize the attack surface of the final production image.
- **Non-root user**: The application runs as a dedicated `statuspulse` user.
- **Vulnerability Scanning**: CI pipeline includes `Trivy` or `Docker Scout` scans for HIGH and CRITICAL vulnerabilities.

## Network Security
- **Reverse Proxy (Nginx)**: All traffic is proxied through Nginx.
- **Security Headers**: The following headers are enforced:
    - `X-Content-Type-Options: nosniff`
    - `X-Frame-Options: DENY`
    - `X-XSS-Protection: 1; mode=block`
    - `Strict-Transport-Security` (HSTS)
- **Rate Limiting**: Limited to 100 requests per minute per IP.
- **Firewall (UFW)**: Only ports 22, 80, and 443 are open.

## Reporting a Vulnerability
If you find a security issue, please open a GitHub Issue or contact the maintainer directly.
