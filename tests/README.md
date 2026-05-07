# StatusPulse Integration Tests

This directory contains the automated test suite for verifying the deployment.

## `test_integration.sh`

This is a shell-based integration test suite used in the CI/CD pipeline.

### What it tests:
1. **Connectivity**: Retries until the service is reachable and healthy.
2. **Root Endpoint**: Verifies the service name and version.
3. **Service Lifecycle**: Tests creating a service and then listing it to ensure it was persisted.
4. **Incident Lifecycle**: Tests creating an incident for a service.
5. **Conflict Handling**: Verifies that the API correctly returns a `409 Conflict` when trying to create a duplicate service.

### Running manually:
You can run these tests against any reachable StatusPulse instance (local or remote):

```bash
./test_integration.sh http://localhost:8000
```

### CI/CD Integration
In the `.github/workflows/ci.yml` pipeline, this script is executed after `docker compose up -d` to ensure the live stack is functional before allowing a merge or deployment.
