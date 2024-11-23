#!/bin/bash

echo "Starting Docker deployment..."

# Go to the application directory
cd /home/ec2-user/ape-serve-beer

# Pull latest changes
echo "Pulling latest changes..."
git pull

# Build the Docker image
echo "Building Docker image..."
docker build -t ape_serve_beer .

# Stop and remove the old container if it exists
echo "Stopping old container..."
docker stop ape_serve_beer || true
docker rm ape_serve_beer || true

# Start the new container
echo "Starting new container..."
docker run -d \
  --name ape_serve_beer \
  -p 80:80 \
  -e RAILS_MASTER_KEY=$(cat config/master.key) \
  -v $(pwd)/storage:/rails/storage \
  -v $(pwd)/db:/rails/db \
  ape_serve_beer

echo "Deployment completed!"
