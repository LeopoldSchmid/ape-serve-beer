#!/bin/bash

# Create backup directory if it doesn't exist
mkdir -p /home/ec2-user/backups

# Create timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Backup the SQLite database
cp /home/ec2-user/ape-serve-beer/db/production.sqlite3 /home/ec2-user/backups/production_${TIMESTAMP}.sqlite3

# Keep only the last 5 backups
cd /home/ec2-user/backups
ls -t | tail -n +6 | xargs -r rm --

echo "Backup completed: production_${TIMESTAMP}.sqlite3"
