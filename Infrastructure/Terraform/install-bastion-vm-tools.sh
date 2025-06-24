#!/bin/bash
# Update packages
sudo apt-get update -y
sudo apt-get upgrade -y

# Install curl and apt-transport-https
sudo apt-get install -y curl apt-transport-https ca-certificates gnupg

# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubectl

# Optional: clean up
apt-get clean