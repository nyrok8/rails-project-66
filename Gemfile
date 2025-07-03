# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.2.2'

gem 'jsbundling-rails'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.2', '>= 7.2.2.1'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'simple_form'
gem 'slim-rails'

gem 'sentry-rails'
gem 'sentry-ruby'

gem 'octokit'
gem 'omniauth-github'
gem 'omniauth-rails_csrf_protection'

gem 'mailtrap'

gem 'dry-container'

gem 'aasm'
gem 'enumerize'
gem 'pundit'

gem 'tzinfo-data', platforms: %i[windows jruby]

gem 'bootsnap', require: false

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'

  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false

  gem 'slim_lint', require: false

  gem 'sqlite3', '>= 1.4'

  gem 'dotenv-rails'
end

group :test do
  gem 'faker'
  gem 'minitest-power_assert'
  gem 'webmock'
end

group :production do
  gem 'pg'
end
