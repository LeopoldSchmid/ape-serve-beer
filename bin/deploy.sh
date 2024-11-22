#!/bin/bash

echo "Starting deployment..."

# Go to the application directory
cd /home/ec2-user/ape-serve-beer

# Pull latest changes
echo "Pulling latest changes..."
git pull

# Install dependencies
echo "Installing dependencies..."
bundle install

# Migrate database (this preserves data)
echo "Migrating database..."
RAILS_ENV=production bundle exec rails db:migrate

# Precompile assets
echo "Precompiling assets..."
RAILS_ENV=production bundle exec rails assets:precompile

# Restart Puma
echo "Restarting Puma..."
if [ -f tmp/pids/puma.pid ]; then
    kill -USR2 `cat tmp/pids/puma.pid`
else
    RAILS_ENV=production bundle exec puma -C config/puma.rb
fi

echo "Deployment completed!"
