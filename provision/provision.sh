#!/bin/bash


    yum update
    yum clean all

    # Install epel-release-7
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

    PACKAGES="httpd mariadb-server mariadb php php-mysql php-mcrypt php-common curl tree vim"


    debconf-set-selections <<< "mysql-server mysql-server/root_password password password"
    debconf-set-selections <<< "mysql-server mysql-server/root_password_again password password"

    echo "Install $PACKAGES"
    yum install $PACKAGES -y

    echo "INIT SERVICES....."

    echo "INIT APACHE SERVICE"
    systemctl start httpd.service
    systemctl enable httpd.service
    echo "INIT MYSQL SERVER...."
    systemctl start mariadb
    systemctl enable mariadb.service

    #create sites httpd folders
    mkdir /etc/httpd/sites-available
    mkdir /etc/httpd/sites-enabled
    cp -f /home/vagrant/templates/httpd.conf /etc/httpd/conf/httpd.conf

    cp /home/vagrant/provision/templates/example.apache /etc/httpd/sites-available/example.conf
    ln -s /etc/httpd/sites-available/example.conf /etc/httpd/sites-enabled/example.conf
    apachectl restart

    echo "Install composer"
    curl  -k -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
