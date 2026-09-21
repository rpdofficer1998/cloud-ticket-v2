#!/bin/bash

set -e

sudo apt-get update

sudo apt-get install -y docker.io docker-compose-v2

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ubuntu