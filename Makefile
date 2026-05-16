.PHONY: up down build setup install console migrate logs bash test create-migration npm

COMPOSE = docker compose

up:
	$(COMPOSE) up -d

down:
	$(COMPOSE) down

build:
	$(COMPOSE) build

# First-time setup: build images, install dependencies, prepare database
setup: build install
	$(COMPOSE) run --rm web bin/rails db:prepare

# Re-run after Gemfile or package.json changes
install:
	$(COMPOSE) run --rm --no-deps web bundle install
	$(COMPOSE) run --rm --no-deps web npm install

console:
	$(COMPOSE) exec web bundle exec rails console

# Run migrations
migrate:
	$(COMPOSE) exec web bundle exec rails db:migrate

# Create migration: make create-migration NAME=AddEmailIndexToPeople
create-migration:
ifndef NAME
	$(error NAME is required. Usage: make create-migration NAME=AddEmailIndexToPeople)
endif
	$(COMPOSE) exec web bundle exec rails generate migration $(NAME)

# Pass SERVICE=web to tail a single service: make logs SERVICE=web
logs:
	$(COMPOSE) logs -f $(SERVICE)

bash:
	$(COMPOSE) exec web bash

test:
	$(COMPOSE) run --rm -e RAILS_ENV=test web bundle exec rails test

## Run npm install inside the web container (requires running container)
npm:
	$(COMPOSE) exec web npm install
