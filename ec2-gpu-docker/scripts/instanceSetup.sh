#!/bin/bash -xe

# Update && upgrade
apt-get update && apt-get -y upgrade

# Install required and useful packages..
echo -e "Installing packages..."
apt-get install -y  linux-headers-$(uname -r) \
                    htop \
                    unzip \
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

###
# Install NVIDIA container tooklit / https://github.com/NVIDIA/nvidia-docker
##
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
   tee /etc/apt/sources.list.d/nvidia-docker.list
echo -e "Install container toolkit ..."
apt-get -y install nvidia-container-toolkit

###
# Post installation steps...
##
sed -i "/PATH=/c\PATH=/usr/local/cuda-10.2/bin:/usr/local/cuda-10.2/NsightCompute-2019.1:$PATH" /etc/environment
echo export $(cat /etc/environment | grep PATH) >> /etc/profile

echo -e "Restarting docker engine..."
systemctl restart docker
