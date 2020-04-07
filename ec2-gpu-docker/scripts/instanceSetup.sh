#!/bin/bash -xe

# Update && upgrade
apt-get update && apt-get -y upgrade

# Install required packages
echo - "Installing packages..."
apt-get install -y htop docker.io docker-compose git mesa-utils
