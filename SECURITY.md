# Security Policy - StatusPulse

## Secret Management
- No secrets (passwords, keys, tokens) are committed to the repository.
- Use `.env` file for local development (excluded via `.gitignore`).
- Use GitHub Actions Secrets for CI/CD environment variables.
- Production secrets are managed on the server via a secured `.env` file with `600` permissions.

## Vulnerability Management
- **Scan Date**: 2026-05-07
- **Findings**: 
    - `gunicorn` < 22.0.0 (CVE-2024-1135, CVE-2024-6827) - **FIXED** (Updated to 23.0.0)
    - `starlette` < 0.40.0 (CVE-2024-47874) - **FIXED** (Updated via FastAPI 0.115.0)
    - `wheel` < 0.46.2 (CVE-2026-24049) - **FIXED** (Automated build update)
- **Status**: All HIGH/CRITICAL vulnerabilities identified by Trivy have been mitigated.


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
