#!/bin/bash

#Update
sudo yum update

# Instal Flask
sudo yum install -y epel-release
sudo yum install python3-pip -y -y
pip3 install Flask

#Install MySQL
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm
sudo yum install mysql-server -y
sudo yum install mysql-devel -y
sudo yum install gcc -y
sudo yum install python3-devel -y
pip3 install flask-mysqldb
sudo systemctl start mysqld

#Create and fill Database
sudo mysql -h localhost -u root  < /home/vagrant/init.sql

#Run application
#cd /home/vagrant
#export FLASK_APP=apirest_mysql.py
#/usr/local/bin/flask run --host=0.0.0.0
