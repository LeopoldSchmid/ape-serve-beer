#!/bin/bash

# Enable BuildKit for better caching
export DOCKER_BUILDKIT=1

# Go to the application directory
cd /home/ec2-user/ape-serve-beer

# Stop and remove existing container
echo "Stopping old container..."
docker stop ape_serve_beer || true
docker rm ape_serve_beer || true

# Pull latest changes
echo "Pulling latest changes..."
git fetch origin
git reset --hard origin/master

# Ensure master.key exists
if [ ! -f config/master.key ]; then
    echo "Creating master.key..."
    mkdir -p config
    echo "c399383b7b3376740441cefb1ebc6272" > config/master.key
    chmod 600 config/master.key
fi

# Build new image
echo "Building new image..."
docker build -t ape_serve_beer .

# Create required directories if they don't exist
mkdir -p storage
mkdir -p tmp/pids
mkdir -p log
mkdir -p db

# Start new container
echo "Starting new container..."
docker run -d \
  --name ape_serve_beer \
  -p 3000:3000 \
  -e RAILS_MASTER_KEY="$(cat config/master.key)" \
  -e RAILS_ENV=production \
  -e RAILS_LOG_TO_STDOUT=true \
  -e SECRET_KEY_BASE="$(bundle exec rails secret)" \
  -e DATABASE_URL="sqlite3:/rails/db/production.sqlite3" \
  -v "$(pwd)/storage:/rails/storage" \
  -v "$(pwd)/db:/rails/db" \
  -v "$(pwd)/log:/rails/log" \
  -v "$(pwd)/tmp:/rails/tmp" \
  --restart unless-stopped \
  ape_serve_beer

echo "Running database migrations..."
docker exec ape_serve_beer rails db:migrate RAILS_ENV=production

echo "Deployment completed!"
echo "Container status:"
docker ps -f name=ape_serve_beer
echo "Recent logs:"
docker logs --tail 50 ape_serve_beer
