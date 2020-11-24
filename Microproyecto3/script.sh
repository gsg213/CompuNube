#!/bin/bash

## Docker aprovisioning
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "check fingerprint bellow: 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88"

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

sudo apt-get install docker-ce -y docker-ce-cli containerd.io

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

sudo apt install nodejs

echo "Node version: "
node --version

echo "npm version: "
npm --version

sudo wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb

sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update

sudo apt-get install python3-venv -y

echo "Azure func: "
sudo apt-get install azure-functions-core-tools-3

echo ".Net Core SDK: "
sudo apt-get update; \
  sudo apt-get install -y apt-transport-https && \
  sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-3.1

curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

