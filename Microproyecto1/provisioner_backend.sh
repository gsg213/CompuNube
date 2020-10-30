#!/bin/bash

MACHINEIP=$1
MACHINEID=$(($MACHINEIP - 1))

# ##### Aprovisionando lxd ##########
echo "Installing LXD";
sudo snap install lxd --channel=4.0/stable ;
newgrp lxd;
echo "Initializing LXD cluster node";
sed -n -i -e '/server_address: /r /vagrant/config/certificate/cluster_certificate.txt' -e 1x -e '2,${x;p}' -e '${x;p}' /vagrant/config/preseeds/preseedVM${MACHINEIP}.YAML
sudo cat /vagrant/config/preseeds/preseedVM${MACHINEIP}.YAML | sudo lxd init --preseed;
sleep 10
# Creating container
echo "Creating container web${MACHINEID}"
lxc launch ubuntu:18.04 web${MACHINEID};
sleep 10
# Install apache
echo "Installing Apache and configuration";
lxc exec web${MACHINEID} -- apt-get update;
lxc exec web${MACHINEID} -- apt-get upgrade -y;
lxc exec web${MACHINEID} -- apt-get install apache2 -y
lxc exec web${MACHINEID} -- systemctl enable apache2
# Push custom index
echo "Configuring Index.html";
lxc file push /vagrant/config/files/index${MACHINEID}.html web${MACHINEID}/var/www/html/index.html
# Restart server
echo "Restarting Apache";
lxc exec web${MACHINEID} -- systemctl restart apache2

# Obtainint ID for backup Machine
if [ $MACHINEID ==  1 ]
  then
    echo "Configuring backup for web2"; 
    MACHINEBUID=2
  else
    echo "Configuring backup for web1"; 
    MACHINEBUID=1
fi

# Creating Backup containers
echo "Creating backup container backupWeb${MACHINEBUID}"
lxc launch ubuntu:18.04 backupWeb${MACHINEBUID} --target vagrantVM${MACHINEIP};
sleep 10
# Install apache
echo "Installing Apache and configuration";
lxc exec backupWeb${MACHINEBUID} -- apt-get update;
lxc exec backupWeb${MACHINEBUID} -- apt-get upgrade -y;
lxc exec backupWeb${MACHINEBUID} -- apt-get install apache2 -y;
lxc exec backupWeb${MACHINEBUID} -- systemctl enable apache2;
# Push custom index
echo "Configuring Index.html";
lxc file push /vagrant/config/files/indexBUp${MACHINEBUID}.html backupWeb${MACHINEBUID}/var/www/html/index.html
# Restart server
echo "Restarting Apache";
lxc exec backupWeb${MACHINEBUID} -- systemctl restart apache2

# Starting haproxy once all containers have been created
if [ $MACHINEIP == 3 ]
  then
    echo "Starting haproxy"; 
    lxc exec haproxy -- systemctl start haproxy
    lxc exec haproxy -- systemctl reload haproxy
  else
    echo "The containers are not created yet"
fi
echo "Finish configuring Virtual Machine ${MACHINEIP}"

