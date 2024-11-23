#!/bin/bash

echo "Starting Docker deployment..."

# Go to the application directory
cd /home/ec2-user/ape-serve-beer

# Reset any local changes and pull latest
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

# Create necessary directories
mkdir -p storage
mkdir -p db

# Build the Docker image
echo "Building Docker image..."
sudo docker build -t ape_serve_beer .

# Stop and remove the old container if it exists
echo "Stopping old container..."
sudo docker stop ape_serve_beer || true
sudo docker rm ape_serve_beer || true

# Start the new container
echo "Starting new container..."
sudo docker run -d \
  --name ape_serve_beer \
  -p 80:80 \
  -e RAILS_MASTER_KEY=$(cat config/master.key) \
  -v $(pwd)/storage:/rails/storage \
  -v $(pwd)/db:/rails/db \
  --restart unless-stopped \
  ape_serve_beer

echo "Deployment completed!"

# Show container status
echo "Container status:"
sudo docker ps | grep ape_serve_beer
