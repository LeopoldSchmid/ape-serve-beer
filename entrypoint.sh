#!/bin/bash
set -e

# Environment checks
if [ -z "$RAILS_ENV" ]; then
  export RAILS_ENV=production
fi

if [ -z "$SECRET_KEY_BASE" ]; then
  echo "ERROR: SECRET_KEY_BASE is not set!"
  exit 1
fi

# Database setup and migrations
echo "Running database migrations..."
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:setup

# Remove any existing server.pid file
rm -f /rails/tmp/pids/server.pid

# Execute the main command
exec "$@"
