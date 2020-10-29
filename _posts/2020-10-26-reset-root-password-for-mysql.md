 ---
layout: post
title: MySql 重置 root 密码
tags: [centos]
categories:
- blog
---

### MySql 重置 root 密码

### 背景

- 忘记 root 密码
- 需要重启 mysql 服务

### 内容

```
# 配置 systemd 参数跳过授权表启动 MySQL
systemctl set-environment MYSQLD_OPTS="--skip-grant-tables"  
systemctl start mysqld

# 进入 MySQL 重置密码
mysql -u root
>update mysql.user SET authentication_string = PASSWORD('YOUR_PASS_VALUE'), password_expired = 'N' WHERE User = 'root' AND Host = 'localhost';
>FLUSH PRIVILEGES;
>exit

# 取消 systemd 参数重启 MySQL 服务
systemctl stop mysqld
systemctl unset-environment MYSQLD_OPTS
systemctl start mysqld
```
