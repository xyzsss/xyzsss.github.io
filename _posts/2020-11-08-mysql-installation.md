---
layout: post
title: MySQL 5.7 安装
tags: [MySQL]
categories:
- blog
---


## 1，背景:

    操作系统：CentOS
    安装方式：yum
             源码编译

## 2，yum 安装

```
yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm -y 
yum install mysql-community-server -y
grep 'A temporary password' /var/log/mysqld.log |tail -1
service mysqld start
/usr/bin/mysql_secure_installation
mysql -h localhost -u root -p 
mysql -V
```

## 3，Source 安装

```
useradd  -s /sbin/nologin  mysql
mkdir /data
yum  install cmake ncurses-devel gcc  gcc-c++  vim  lsof bzip2 openssl-devel -y

# boost 下载可能会很慢
wget -O https://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz
tar -zxf boost_1_59_0.tar.gz -C /usr/local/

wget https://mirrors.huaweicloud.com/mysql/Downloads/MySQL-5.7/mysql-5.7.30.tar.gz
tar xf mysql-5.7.30.tar.gz && cd mysql-5.7.30
cmake -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/data -DSYSCONFDIR=/usr/local/mysql -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_MEMORY_STORAGE_ENGINE=1 -DWITH_READLINE=1 -DMYSQL_UNIX_ADDR=/data/mysql.sock -DMYSQL_TCP_PORT=3306 -DENABLED_LOCAL_INFILE=1 -DWITH_PARTITION_STORAGE_ENGINE=1 -DEXTRA_CHARSETS=all -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DDOWNLOAD_BOOST=1 -DWITH_BOOST=/usr/local/boost_1_59_0
# 编译需要花点时间
make && make install


ln -s /usr/local/mysql/bin/*  /usr/bin/
touch /usr/local/mysql/mysql-error.log /usr/local/mysql/mysql-slow.log
chown -R mysql:mysql /data /usr/local/mysql
cp support-files/mysql.server  /etc/init.d/mysqld
chmod +x /etc/init.d/mysqld
# 修改 /etc/init.d/mysqld 配置
# 手动修改
basedir=/usr/local/mysql
datadir=/data
mysqld_pid_file_path=/usr/local/mysql
conf=/etc/my.cnf
```

## 4，MySQL 配置

```
cat > /etc/my.cnf << 'EOF'
[client]
port = 3306
socket = /usr/local/mysql/mysqld.sock

[mysqld]
port = 3306
pid-file = /usr/local/mysql/mysqld.pid
socket = /usr/local/mysql/mysqld.sock
datadir = /data
basedir = /usr/local/mysql
log_error = /usr/local/mysql/mysql-error.log
user=mysql

slow_query_log = 1
long_query_time = 1 
slow_query_log_file = /usr/local/mysql/mysql-slow.log
EOF
```

## 5，启动MySQL

```
chkconfig mysqld on
# 记住密码
/usr/local/mysql/bin/mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/data
/etc/init.d/mysqld restart
# 或者 systemctl restart mysqld
mysql -p
#第一次登陆需要重置root密码
> set password = password('RRef4oD&ekln');
```


## 附录


重置密码
```
5.5 ：update mysql.user set password=PASSWORD('RRef4oD&ekln') where User='root';  
5.7 ：update mysql.user set authentication_string=password('RRef4oD&ekln') where user='root';
```

重新编译

```
## 出错的情况下 需要重新编译才执行 否则不用操作 下面这两条命令
make clean
rm -f CMakeCache.txt
```

ref：

      https://blog.csdn.net/zhang_referee/article/details/88212695
      https://yq.aliyun.com/articles/581182


