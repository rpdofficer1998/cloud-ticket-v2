#!/bin/bash

set -e

cd /home/ssm-user/cloud-ticket

echo "=== Build backend image ==="
docker compose -f docker/docker-compose.yml build backend

echo "=== Restart application ==="
docker compose -f docker/docker-compose.yml up -d

echo "=== Current containers ==="
docker compose -f docker/docker-compose.yml ps