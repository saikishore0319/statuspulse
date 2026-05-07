# StatusPulse Integration Tests

Automated test suite to verify the end-to-end functionality of the StatusPulse stack.

## `test_integration.sh`

A robust shell-based test suite that validates:
1. **API Readiness**: Retries until the health endpoint returns a healthy status.
2. **Core Functionality**: Validates Root, Service management, and Incident reporting endpoints.
3. **Data Integrity**: Ensures services and incidents are persisted correctly.
4. **Error Handling**: Verifies correct `409 Conflict` responses for duplicate entries.

## Running Tests

### Local / CI Environment
The tests run automatically in the GitHub Actions CI pipeline against `http://localhost:8000`.

### Production Environment
You can manually verify your live deployment from any terminal:
```bash
./test_integration.sh https://statuspulse1.duckdns.org
```

## Success Criteria
- All 7 test stages must return a `pass`.
- The script must exit with status `0`.
