.PHONY: up down build setup install console migrate logs bash test

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

migrate:
	$(COMPOSE) exec web bundle exec rails db:migrate

# Pass SERVICE=web to tail a single service: make logs SERVICE=web
logs:
	$(COMPOSE) logs -f $(SERVICE)

bash:
	$(COMPOSE) exec web bash

test:
	$(COMPOSE) run --rm -e RAILS_ENV=test web bundle exec rails test
