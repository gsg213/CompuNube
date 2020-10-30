#!/bin/bash

# ##### Aprovisionando lxd ##########
echo "Install lxd";
sudo snap install lxd --channel=4.0/stable ;
echo "Creating group and initializing lxd";
newgrp lxd;
echo "Loading HAProxy preseed";
sudo cat /vagrant/config/preseeds/preseedVM1.YAML | lxd init --preseed;
sleep 10
echo "Creating certificate"
sed ':a;N;$!ba;s/\n/\n    /g;s/^/    /g' /var/snap/lxd/common/lxd/server.crt > /vagrant/config/certificate/cluster_certificate.txt
echo "Creating container haproxy"
lxc launch ubuntu:18.04 haproxy;
sleep 10
# Install haproxy
echo "Installing haproxy";
lxc exec haproxy -- apt-get update;
lxc exec haproxy -- apt-get upgrade -y;
lxc exec haproxy -- apt-get install haproxy -y;
lxc exec haproxy -- systemctl enable haproxy;
# Modificando archivo cfg
echo "Modify haproxy.cfg file"
lxc file push /vagrant/config/files/haproxy.cfg haproxy/etc/haproxy/haproxy.cfg
# Pushing custom sorry file
#echo "Creating servers unavailables message"
lxc file push /vagrant/config/files/indexDown.http haproxy/etc/haproxy/errors/sorry_page.http
# Port forwarding
echo "Port forwarding";
lxc config device add haproxy http80 proxy listen=tcp:0.0.0.0:80 connect=tcp:127.0.0.1:80
echo "Finish configuring Virtual Machine 1"