# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define :servidorRest do |servidorRest|
    servidorRest.vm.box = "bento/centos-7.8"
    servidorRest.vm.network :private_network, ip: "192.168.60.3"
    servidorRest.vm.provision "file", source: "apirest_mysql.py", destination: "/home/vagrant/apirest_mysql.py"
    servidorRest.vm.provision "file", source: "init.sql", destination: "/home/vagrant/init.sql"
    servidorRest.vm.provision "shell", path: "script.sh"
    servidorRest.vm.hostname = "servidorRest"
  end
end
