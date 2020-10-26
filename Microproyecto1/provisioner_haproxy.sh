#!/bin/bash

# ##### Aprovisionando lxd ##########
echo "Install lxd";
sudo snap install lxd --channel=4.0/stable ;
echo "Creating group and initializing lxd";
newgrp lxd;
echo "Loading HAProxy preseed";
sudo cat /vagrant/preseed_loadbalancer.yaml | lxd init --preseed;
sleep 10
#lxc remote add images images.linuxcontainers.org ;
echo "Create container";
lxc launch ubuntu:18.04 server;
sleep 10

# Install haproxy
lxc exec server -- apt update;
lxc exec server -- apt upgrade -y;
echo "Install haproxy";
lxc exec server -- apt install haproxy -y;
lxc exec server -- systemctl enable haproxy;

# modificando archivo cfg
echo "Modify haproxy.cfg file"
sudo cat <<STOP_CFG> /etc/haproxy/haproxy.cfg
backend web-backend
   balance roundrobin
   stats enable
   stats auth admin:admin
   stats uri /haproxy?stats
   stats refresh 1s

   server web2 192.168.100.2:80 check
   server web3 192.168.100.3:80 check

frontend http
  bind *:80
  default_backend web-backend
STOP_CFG

# Restart server
echo "Start haproxy";
lxc exec server -- systemctl start haproxy
# Port forwarding
echo "Port forwarding";
lxc config device add haproxy http proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80


