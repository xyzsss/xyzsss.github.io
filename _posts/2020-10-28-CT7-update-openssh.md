---
layout: post
title: centos7.4  升级 openssh 服务 
tags: [centos, 升级]
categories:
- blog
---

## Note  
---

##### ENV: CentOS

## 环境
    主机能访问外网，可以依赖包升级操作

## 目录  
    - 安装基本依赖  
    - 升级 openssl  
    - 升级 openssh   
## 内容
```
# 1，install dependency
yum install -y gcc-c++ glibc make autoconf openssl openssl-devel pam-devel wget
yum install -y pam* zlib*

# 2.1，ssl backup 
mv /usr/bin/openssl /usr/bin/openssl-bak
mv /usr/include/openssl /usr/include/openssl-bak 

# 2.2，ssl download 
cd /tmp && wget https://www.openssl.org/source/old/1.0.2/openssl-1.0.2u.tar.gz
tar -zxf openssl-1.0.2u.tar.gz

# 2.3，ssl source build 
cd openssl-1.0.2u
./config shared && make && make install
echo $?

# 2.4，ssl recall
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/include/openssl /usr/include/openssl
echo "/usr/local/ssl/lib" >> /etc/ld.so.conf
/sbin/ldconfig

# 2.5，ssl version check
openssl version

# 3.1，ssh version check and upgrade
ssh -V
yum -y install openssh

# 3.2，ssh backup
mv /etc/ssh /etc/ssh-bak

# 3.3，ssh download
cd /tmp && wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-8.4p1.tar.gz
tar zxf openssh-8.4p1.tar.gz

# 3.4，ssh build and install
cd openssh-8.4p1
./configure --prefix=/usr/ --sysconfdir=/etc/ssh --with-openssl-includes=/usr/local/ssl/include --with-ssl-dir=/usr/local/ssl --with-zlib --with-md5-passwords --with-pam  
make && make install

# 3.5，ssh config file /etc/ssh/sshd.config modify
echo "UsePAM yes" >> /etc/ssh/sshd.config
echo "PermitRootLogin yes" >> /etc/ssh/sshd.config

# 3.6，ssh old systemd files remove
mv  /usr/lib/systemd/system/sshd.service  /usr/lib/systemd/system/sshd.service.bak
mv  /usr/lib/systemd/system/sshd.socket /usr/lib/systemd/system/sshd.socket.bak


# 3.8 ssh service restart 
cp contrib/redhat/sshd.init  /etc/init.d/sshd
/etc/init.d/sshd restart 
# Also:  systemctl restart sshd
```



 
