# StatusPulse Application

This directory contains the core FastAPI application for StatusPulse.

## Technical Stack
- **Framework**: FastAPI (Asynchronous Python)
- **Validation**: Pydantic
- **Database**: PostgreSQL (via `psycopg2`)
- **Messaging/Caching**: Redis

## API Endpoints

### Public / Status
- `GET /`: Root info and version.
- `GET /health`: Detailed health status of API, Database, and Redis.
- `GET /docs`: Swagger UI documentation.

### Services Management
- `GET /services`: List all monitored services.
- `POST /services`: Register a new service for monitoring.
    - Body: `{"name": "string", "url": "string"}`

### Incident Management
- `GET /incidents`: List all reported incidents (sorted by newest).
- `POST /incidents`: Create a new incident.
    - Body: `{"service_name": "string", "title": "string", "description": "string", "severity": "minor|major|critical"}`

## Environment Variables
The application expects the following variables (loaded via Docker Compose or `.env`):
- `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD`
- `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`

## Local Running (without Docker)
1. Install dependencies: `pip install -r requirements.txt`
2. Run with Uvicorn: `uvicorn main:app --reload`
