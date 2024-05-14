#!/bin/bash

MYSQL_ROOT_PASSWORD='root'
MYSQL_DATABASE='testing'
MYSQL_USER='testing'
MYSQL_USER_PASSWORD='secret'
PROJECTFOLDER='Project'

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

# LINUX STUFF
sudo apt-get update
sudo apt-get -y install vim 
sudo apt-get -y install git

# APPACHE STUFF
sudo apt-get install -y apache2

# HTML Resommended Apache Settings
sudo a2enmod expires
sudo a2enmod headers
sudo a2enmod include
sudo a2enmod rewrite

# setup hosts file
sudo yes | cp ./config/apache2/000-default.conf /etc/apache2/sites-available/000-default.conf

# PHP STUFF
sudo apt-get -y install --no-install-recommends php8.1

# Make PHP and Apache Friends
sudo apt-get -y install libapache2-mod-php
sudo service apache2 restart

# Base stuff
sudo apt-get -y install php-common
sudo apt-get -y install php-all-dev

# Common usefull stuff
sudo apt-get -y install php-mcrypt
sudo apt-get -y install php-zip

# Install PHP extentions
sudo apt-get install -y php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath

# Install Composer
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# MYSQL STUFF
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
sudo apt-get -y install mysql-server
sudo systemctl start mysql.service

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
# sudo apt-get -y install phpmyadmin

# Config mysql
sudo yes | cp ./config/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

MYSQL_PWD=$MYSQL_ROOT_PASSWORD mysql --user=root <<-EOSQL
    CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY $MYSQL_USER_PASSWORD;
    CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}%\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

sudo systemctl restart mysql.service

sudo service apache2 restart