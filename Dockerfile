# syntax=docker/dockerfile:1.4

ARG RUBY_VERSION=3.2.2
ARG NODE_VERSION=23.x
ARG YARN_VERSION=1.22.22

FROM ruby:${RUBY_VERSION}-slim AS base

ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development test"

WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential git curl libjemalloc2 libvips libpq5 \
    pkg-config python3 libpq-dev && \
    curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - && \
    apt-get install --no-install-recommends -y nodejs && \
    npm install -g yarn@${YARN_VERSION} eslint && \
    gem install rubocop && \
    rm -rf /var/lib/apt/lists/*

FROM base AS builder

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN --mount=type=cache,target=/usr/local/bundle \
    bundle install --jobs 4 --retry 3 && \
    bundle exec bootsnap precompile --gemfile

COPY package.json yarn.lock ./
RUN --mount=type=cache,target=/root/.cache/yarn \
    yarn install --frozen-lockfile

COPY . ./

# Precompile Bootsnap and Rails assets
RUN bundle exec bootsnap precompile --gemfile && \
    SECRET_KEY_BASE=placeholder bundle exec rails assets:precompile

FROM base AS release

WORKDIR /app

# Copy built gems and application code
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

# Create a non-root user and set permissions
RUN groupadd --system --gid 1000 rails && \
    useradd --system --uid 1000 --gid 1000 --create-home rails && \
    chown -R rails:rails /app

USER rails

# Expose the port and use Render's $PORT variable
ENV PORT 3000
EXPOSE 3000

# Start the Rails server on the appropriate interface and port
CMD ["sh", "-c", "bin/rails server -b 0.0.0.0 -p ${PORT}"]
