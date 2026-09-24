#!/bin/bash

set -e

sudo apt-get update

sudo apt-get install -y docker.io docker-compose-v2 curl unzip

sudo systemctl enable docker
sudo systemctl start docker

sudo usermod -aG docker ubuntu

# Amazon SSM Agent has been pre-installed
# Install AWS CLI v2
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | sudo bash -s -- --system