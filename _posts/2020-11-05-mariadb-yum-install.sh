---
layout: post
title: MariaDB yum 安装
tags: [MariaDB]
categories:
- blog
---

## MariaDB 安装-10.1

MySQL 和 MariaDB 兼容列表：https://mariadb.com/kb/en/library/mariadb-vs-mysql-compatibility/



### 0，配置 mariadb 源

###### MySQL 10.1 源

    cat > /etc/yum.repos.d/MariaDB.repo  <<EOF
    [mariadb]
    name = MariaDB
    baseurl = http://yum.mariadb.org/10.1/centos6-amd64
    gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    gpgcheck=1
    EOF



###### MySQL 5.5 源

```
cat >  /etc/yum.repos.d/mariadb.repo <<EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/5.5/rhel7-amd64/
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
```



###  1，安装 mariadb 服务

    # 升级系统
    yum -y update
    # 检查 yum 可用性
    yum list
    # 卸载原来的 mysql-server 版本,如果存在的话
    yum remove mysql-server
    
    # 建议安全前配置代理加速安装
    # 安装
    yum install MariaDB-server MariaDB-client -y
    service mysql start
    chkconfig mysql on
    # 设置 root 密码，然后移除test数据库
    mysql_secure_installation
    service mysql restart
    chkconfig mysql on
    mysql -u root -p

### 2，创建远程登录账户/授予所有数据库所有表的权限

    create user USER_NAME; 
    GRANT ALL PRIVILEGES ON *.* TO USER_NAME@"%" IDENTIFIED BY 'USER_PASSWORD' WITH GRANT OPTION;
    flush privileges;

