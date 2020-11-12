---
layout: post
title: MySQL重置root密码
tags: [MySQL]
categories:
- blog
---


通过跳过授权表启动mysql，进行无认证访问数据库进行更改。


- 1，systemd 管理服务
- 2，service 管理服务


## 2，systemd 管理服务

```
systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"
systemctl restart mysqld
mysql
UPDATE mysql.user SET authentication_string = PASSWORD('king') WHERE User = 'root' AND Host = 'localhost';
FLUSH PRIVILEGES;
systemctl unset-environment MYSQLD_OPTS
systemctl restart mysqld
```


## 3，service 管理服务

```
# 1, 停止数据库服务
# 如果有在运行的话
service mysql stop

# 2,以安全模式启动
mysqld_safe --skip-grant-tables --skip-networking &
# --skip-networking，避免远程无密码登录 MySQL

# 3,重置 root 账号密码
# 无密码登陆
mysql -u root  
# 重置密码
# update user set password=PASSWORD("your_password_here") where User='root'; 
update mysql.user set password=PASSWORD("passwordmysqlslap -a") where User='root';
flush privileges;
exit;

# 4,重启 mysql 服务
service mysql restart
```
