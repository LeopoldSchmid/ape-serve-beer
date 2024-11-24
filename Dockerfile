# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t ape_serve_beer .
# docker run -d -p 3000:3000 -e RAILS_MASTER_KEY=<value from config/master.key> --name ape_serve_beer ape_serve_beer

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.6
FROM ruby:3.3.0-slim as builder

# Install essential Linux packages
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips pkg-config git sqlite3 libsqlite3-dev nodejs npm

# Set working directory
WORKDIR /rails

# Install dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment true && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3

# Copy application code
COPY . .

# Precompile assets
RUN SECRET_KEY_BASE=dummy bundle exec rails assets:precompile

# Create production image
FROM ruby:3.3.0-slim

# Install runtime dependencies
RUN apt-get update -qq && \
    apt-get install -y libvips sqlite3 nodejs npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Create app directory
WORKDIR /rails

# Create rails user
RUN groupadd -r rails && useradd -r -g rails -d /rails -s /bin/false rails

# Copy app with precompiled assets
COPY --from=builder --chown=rails:rails /rails /rails
COPY --from=builder --chown=rails:rails /usr/local/bundle /usr/local/bundle

# Create and set permissions for required directories
RUN mkdir -p /rails/tmp/pids /rails/tmp/cache /rails/log /rails/storage /rails/db && \
    chown -R rails:rails /rails/tmp /rails/log /rails/storage /rails/db && \
    chmod -R 755 /rails/tmp /rails/log /rails/storage /rails/db

# Switch to rails user
USER rails

# Add entrypoint script
COPY --chown=rails:rails entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Configure the main process to run when running the image
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
