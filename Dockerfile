# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.2.2
FROM ruby:${RUBY_VERSION}-slim AS base

ENV RAILS_ENV=production \
    APP_PATH=/app \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

WORKDIR ${APP_PATH}

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    git \
    libjemalloc2 \
    libvips \
    libpq5 && \
    rm -rf /var/lib/apt/lists/*

FROM base AS build

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    pkg-config \
    python-is-python3 \
    libpq-dev && \
    rm -rf /var/lib/apt/lists/*

ARG NODE_VERSION=20.14.0
ARG YARN_VERSION=1.22.22
ENV PATH=/usr/local/node/bin:${PATH}

RUN curl -fsSL https://github.com/nodenv/node-build/archive/master.tar.gz | \
    tar xz -C /tmp/ && \
    /tmp/node-build-*/bin/node-build "${NODE_VERSION}" /usr/local/node && \
    npm install -g yarn@${YARN_VERSION} && \
    rm -rf /tmp/node-build-*

COPY Gemfile Gemfile.lock ./
RUN bundle install --without "test" && \
    bundle exec bootsnap precompile --gemfile && \
    rm -rf /usr/local/bundle/cache

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

RUN yarn build && yarn build:css && rm -rf node_modules
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

RUN gem install --no-document rubocop && \
    npm install -g eslint

FROM base

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /usr/local/node /usr/local/node
COPY --from=build ${APP_PATH} ${APP_PATH}

ENV PATH=/usr/local/node/bin:${PATH}

RUN groupadd -r rails --gid 1000 && \
    useradd -r -g rails --uid 1000 --create-home --shell /bin/bash rails && \
    chown -R rails:rails ${APP_PATH}
USER 1000:1000

EXPOSE 3000
ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["./bin/rails", "server"]
