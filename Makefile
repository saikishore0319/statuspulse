# Makefile for StatusPulse

# Load environment variables from .env
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

.PHONY: build up down logs test clean shell

build:
	docker compose build

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f

test:
	@echo "Running integration tests..."
	@curl -f http://localhost:$(APP_PORT)/health || (echo "Health check failed" && exit 1)
	@echo "All checks passed!"

clean:
	docker compose down -v --rmi all --remove-orphans

shell:
	docker compose exec app bash
