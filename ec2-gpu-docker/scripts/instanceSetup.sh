#!/bin/bash -xe

# Update && upgrade
apt-get update && apt-get -y upgrade

# Install required and useful packages..
echo -e "Installing packages..."
apt-get install -y  linux-headers-$(uname -r) \
                    htop \
                    docker.io \
                    docker-compose \
                    git \
                    mesa-utils \
                    gcc \

###
# Install NVIDIA Tesla Driver and CUDA Toolkit
##
echo -e "Install NVIDIA drivers..."

echo -e "Retrieving the repository..."
distribution=$(. /etc/os-release;echo $ID$VERSION_ID | sed -e 's/\.//g')
curl -o /etc/apt/preferences.d/cuda-repository-pin-600 \
        https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/cuda-$distribution.pin

echo -e "Installing the repository..."
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64/7fa2af80.pub
echo "deb http://developer.download.nvidia.com/compute/cuda/repos/$distribution/x86_64 /" | sudo tee /etc/apt/sources.list.d/cuda.list

echo -e "Update repositories ..."
apt-get update

echo -e "Install driver ..."
apt-get -y install cuda-drivers cuda
