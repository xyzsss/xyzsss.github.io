---
layout: post
title: Nagios install on CentOS6
tags: [Nagios, CentOS6, Installation]
categories:
- blog
---

## Note  
---

#### ref: [How to Install Nagios 4.3.4 on RHEL, CentOS and Fedora](https://www.tecmint.com/install-nagios-in-linux/)  


0, Install Required Dependencies  

    yum install -y httpd httpd-tools php gcc glibc glibc-common gd gd-devel make net-snmp unzip

1, Create Nagios User and Group  

    useradd nagios
    groupadd nagcmd

2, Add user nagios and apache to nagios user group  

    usermod -G nagcmd nagios
    usermod -G nagcmd apache

3, Init Nagios directory  

    mkdir /data/nagios
    cd /data/nagios

4, Download ngios and nagios plugin source package,and untar it

    wget https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.3.4.tar.gz
    wget https://nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz
    tar xvf nagios-4.3.4.tar.gz
    tar xvf nagios-plugins-2.2.1.tar.gz

5, Build the nagios

    cd nagios-4.3.4/
    ./configure --with-command-group=nagcmd
    make
    make install
    make install-init
    make install-commandmode
    make install-config

6, Customizing Nagios Configuration

    vi /usr/local/nagios/etc/objects/contacts.cfg
        ...
        alias                           Nagios Admin            ; Full name of user
        email                           notify@DOMAIN_NAME.com     ;          # added one line here
        ...

7, Setting passwords for user 'nagiosadmin'

    make install-webconf
    htpasswd -s -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
    service httpd restart

8, Install nagios plugins

    cd /data/nagios/nagios-plugins-2.2.1/
    ./configure --with-nagios-user=nagios --with-nagios-group=nagios
    make
    make install

9, Verify Nagios Configuration Files

    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg

10, Enable and Start service

    chkconfig --add nagios
    chkconfig --level 35 nagios on
    chkconfig --add httpd
    chkconfig --level 35 httpd on
    service nagios start  

11, Access nagios web admin page
    Visit “http://Your-server-IP-address/nagios” or “http://FQDN/nagios” 
    With  “nagiosadmin” and password
