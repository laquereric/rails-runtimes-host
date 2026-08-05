FROM ruby:3.3.6-slim-bookworm
RUN apt-get update -qq && apt-get install --no-install-recommends -y build-essential curl git libsqlite3-dev pkg-config && rm -rf /var/lib/apt/lists/*
WORKDIR /rails
ENV RAILS_ENV=production BUNDLE_DEPLOYMENT=1 BUNDLE_WITHOUT="development:test" BUNDLE_PATH=/usr/local/bundle
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN chmod +x bin/rails bin/rake bin/docker-entrypoint && mkdir -p storage tmp/pids log && SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile || true
EXPOSE 3000
ENTRYPOINT ["./bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000", "-e", "production"]
