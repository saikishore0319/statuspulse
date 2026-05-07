# StatusPulse Application

This directory contains the core FastAPI application for StatusPulse.

## Technical Stack
- **Framework**: FastAPI (Asynchronous Python)
- **Validation**: Pydantic
- **Database**: PostgreSQL (via `psycopg2`)
- **Messaging/Caching**: Redis

## Security Hardening
The application is built with security as a priority:
- **Dependencies**: Regularly audited and pinned to secure versions.
- **Non-Root**: Runs as a dedicated `statuspulse` user to minimize container breakout risks.
- **Multi-stage**: Final production image contains zero build tools or source noise.

## API Endpoints

### Public / Status
- `GET /`: Root info and version.
- `GET /health`: Detailed health status of API, Database, and Redis.
- `GET /docs`: Swagger UI documentation.

### Services Management
- `GET /services`: List all monitored services.
- `POST /services`: Register a new service for monitoring.

### Incident Management
- `GET /incidents`: List all reported incidents (sorted by newest).
- `POST /incidents`: Create a new incident.

## Environment Variables
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
- `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`

## Local Development
1. `pip install -r requirements.txt`
2. `uvicorn main:app --reload --port 8000`
