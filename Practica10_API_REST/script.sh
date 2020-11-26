#!/bin/bash

## provisioning

sudo apt-get update

sudo apt-get install python3-pip -y

pip3 install Flask

pip3 freeze | grep Flask

pip3 install requests

git clone https://github.com/omondragon/APIRestFlask
