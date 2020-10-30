#!/bin/bash

# ##### Aprovisionando lxd ##########
echo "Creating group and initializing lxd";
sudo snap install lxd --channel=4.0/stable ;
newgrp lxd;
lxd init --auto;
sleep 10
#lxc remote add images images.linuxcontainers.org ;
lxc launch ubuntu:20.04 server;
sleep 15

# Install apache
lxc exec server -- apt-get update;
lxc exec server -- apt-get upgrade -y;
lxc exec server -- apt-get install apache2 -y
lxc exec server -- systemctl enable apache2
# Push custom index
lxc file push /vagrant/index.html server/var/www/html/index.html
# Restart server
lxc exec server -- systemctl restart apache2
# Port forwarding
lxc config device add server myport80 proxy listen=tcp:192.168.100.3:1026 connect=tcp:127.0.0.1:80;


