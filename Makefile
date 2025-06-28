.PHONY: install lint test

install:
	bundle install
	yarn install --frozen-lockfile

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views

test:
	yarn build
	yarn build:css
	bin/rails test