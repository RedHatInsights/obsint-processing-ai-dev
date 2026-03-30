.PHONY: install sync lock run dev up down logs clean seed

install:
	uv sync

sync:
	uv sync

lock:
	uv lock

run:
	uv run python -m src.server

dev: up
	uv run python -m src.server

# Docker
up:
	docker compose up -d postgres
	@echo "Waiting for postgres..."
	@until docker compose exec postgres pg_isready -U bot -d bot_memory > /dev/null 2>&1; do sleep 1; done
	@echo "Postgres ready"

down:
	docker compose down

logs:
	docker compose logs -f

clean:
	docker compose down -v

# Seed from open-prs.json
seed:
	uv run python seed_from_json.py

# Full stack in Docker
up-all:
	docker compose up -d --build

down-all:
	docker compose down
