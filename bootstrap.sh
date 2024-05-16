#!/bin/bash

# Check if the .env file exists
if [ ! -f .env ]; then
    echo ".env file not found!"
    exit 1
fi

# Load the .env file
set -a
source .env
set +a

# create project folder
sudo mkdir "/var/www/html/${PROJECTFOLDER}"

sudo chown -R $USER:$USER /var/www/html

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

# PHP STUFF
sudo apt-get -y install --no-install-recommends php8.1

# Make PHP and Apache Friends
sudo apt-get -y install libapache2-mod-php

sudo service apache2 restart

# Base stuff
sudo apt-get -y install php-common
sudo apt-get -y install php-all-dev

# Install PHP extentions
sudo apt-get install -y php8.1-cli php8.1-common php8.1-mysql php8.1-zip php8.1-gd php8.1-mbstring php8.1-curl php8.1-xml php8.1-bcmath

# Install Composer
curl -s https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# MYSQL STUFF
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASSWORD"
sudo apt-get -y install mysql-server

# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
# sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
# sudo apt-get -y install phpmyadmin

# Config mysql

MYSQL_PWD=$MYSQL_ROOT_PASSWORD mysql --user=root <<-EOSQL
    DROP USER IF EXISTS '${MYSQL_USER}'@'%';
    CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_USER_PASSWORD}';
    CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
    GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

# setup hosts file
yes | sudo cp /var/www/html/config/vhosts/000-default.conf /etc/apache2/sites-available/000-default.conf

# Changing Apache’s Directory Index (Optional)
yes | sudo cp /var/www/html/config/vhosts/dir.conf /etc/apache2/mods-enabled/dir.conf

# php ini
yes | sudo cp /var/www/html/config/php/php.ini /etc/php/8.1/apache2/php.ini

# setup mysqld config
yes | sudo cp /var/www/html/config/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf


sudo systemctl restart mysql
sudo systemctl apache2 restart
