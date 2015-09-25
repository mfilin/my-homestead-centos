#!/bin/bash

    yum update -y
    yum clean all

    # Install epel-release-7
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

    yum clean all

    PACKAGES="httpd mariadb-server mariadb php56w php56w-opcache php56w-mcrypt php56w-pear php56w-pdo php56w-mbstring php56w-common curl tree vim unzip"
    PACKAGES="$PACKAGES policycoreutils policycoreutils-python selinux-policy selinux-policy-targeted"
    PACKAGES="$PACKAGES libselinux-utils setroubleshoot-server setools setools-console mcstrans wget"

    debconf-set-selections <<< "mysql-server mysql-server/root_password password password"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password password"

    echo "Install $PACKAGES"
    yum install $PACKAGES -y

    echo "Init services....."

    echo "Init apache service"
    systemctl enable httpd.service
    echo "Init mysql server...."
    systemctl start mariadb
    systemctl enable mariadb.service

    echo "Install composer"
    curl  -k -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer

    echo "Install laravel to ./code"
    #install laravel 5.1.6 to code folder
    wget https://github.com/laravel/laravel/archive/master.zip
    unzip master.zip
    cp -r laravel-master/* example/
    rm master.zip
    rm -r laravel-master
    echo "Move .env file"
    cp -f /home/vagrant/provision/templates/.env.example /home/vagrant/example/.env

    echo "Create www folders"
    #create sites httpd folders
    mkdir /etc/httpd/sites-available
    mkdir /etc/httpd/sites-enabled
    cp -f /home/vagrant/provision/templates/httpd.conf /etc/httpd/conf/httpd.conf

    echo "Move userdir"
    cp -f /home/vagrant/provision/templates/userdir.conf /etc/httpd/conf.d/userdir.conf

    echo "Create apache virtual host"
    cp /home/vagrant/provision/templates/example.apache /etc/httpd/sites-available/example.app.conf
    ln -s /etc/httpd/sites-available/example.app.conf /etc/httpd/sites-enabled/example.app.conf
    systemctl start httpd.service

    echo "Change SELinux mode"
    setenforce 0

    yum clean all
