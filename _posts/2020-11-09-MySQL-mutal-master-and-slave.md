---
layout: post
title: MySQL互为主从配置
tags: [MySQL]
categories:
- blog
---

## 0,环境
CentOS 7.5 x 2 安装 MySQL-Server 5.7, 集群模式为互为主从。

Master节点IP为：192.168.96.142、192.168.96.147
VIP为：192.168.96.166

## 1,yum 安装 MySQL-Server

```
yum localinstall https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm -y 
yum install mysql-community-server -y
service mysqld start
# 记住root账户
grep 'A temporary password' /var/log/mysqld.log |tail -1
# 初始化数据库
/usr/bin/mysql_secure_installation
mysql -V
mysql -h localhost -u root -p 
```




## 2,生成 MySQL Server 配置文件

为两台主机都配置 MySQL 的配置文件 /etc/my.cnf.
注意：server-id 必须不一致，否则导致 Slave IO 状态为等待。

yum 安装的目录默认存档在 /var/lib/mysql 中。
可自行修改对应目录，注意目录的权限要给到系统的 mysql 账户。

```
mysql_base_dir=/var/lib/mysql

cat >/etc/my.cnf << EOF
[client]
port = 3306
socket = ${mysql_base_dir}/mysqld.sock

[mysqld]
port = 3306
pid-file = ${mysql_base_dir}/mysqld.pid
socket = ${mysql_base_dir}/mysqld.sock
datadir = ${mysql_base_dir}
basedir = ${mysql_base_dir}
log_error = ${mysql_base_dir}/mysql-error.log
user=mysql

slow_query_log = 1
long_query_time = 1 
slow_query_log_file = ${mysql_base_dir}/mysql-slow.log

# 两个 server id 需要不一致；否则导致 SlaveIO 一直等待
server-id=12
log-bin=mysql-bin
relay-log=relay-log
relay-log-index=relay-log.index
EOF

systemctl restart mysqld
```

## 3, slave 配置

新增复制账户

在Master的数据库中建立一个复制帐户：每个slave使用标准的MySQL用户名和密码连接master。进行复制操作的用户会授予REPLICATION SLAVE权限.

```
# Master (192.168.96.147)机器新增复制账户
create user 'repli'@'192.168.96.142' identified by 'MqiI2KzEyMwD';
grant replication slave on *.* to 'repli'@'192.168.96.142';
flush privileges;

# Slave (192.168.96.142)机器新增复制账户
create user 'repli'@'192.168.96.147' identified by 'MqiI2KzEyMwD';
grant replication slave on *.* to 'repli'@'192.168.96.147';
flush privileges;
```

Slave 配置

```
# 147 同步 142 的日志
# Master(192.168.96.147) 查看状态，获取 Master 的 File 和 Position 值
show master status;
# slave(192.168.96.147) 同步 Master(192.168.96.142) 配置
change master to
    master_host='192.168.96.142', 
    master_user='repli', 
    master_password='MqiI2KzEyMwD', 
    master_log_file='mysql-bin.000001',
    master_log_pos=775;
# 启动 slave
start slave;
# 查看 slave 状态：如果 Slave_IO_Running 和 Slave_SQL_Running 值均为 yes 即可；否则排错
show slave status\G;


# 142 同步 147 的日志
# Master(192.168.96.147) 查看状态，获取 Master 的 File 和 Position 值
show master status;
# slave(192.168.96.147) 同步 Master(192.168.96.142) 配置
change master to
    master_host='192.168.96.142',
    master_user='repli',
    master_password='MqiI2KzEyMwD',
    master_log_file='mysql-bin.000001',
    master_log_pos=775;
# 启动 slave
start slave;
# 查看 slave 状态：如果 Slave_IO_Running 和 Slave_SQL_Running 值均为 yes 即可；否则排错
show slave status\G;
```


## 4,Keepalived  配置高可用

这里配置 vip 为 192.168.96.166。

```
# 1，安装keepalived服务
yum -y install keepalived


# 2，配置
mv /etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf.bak
cat >/etc/keepalived/keepalived.conf<<EOF
! Configuration File for keepalived
global_defs {
   notification_email {
        root@localhost
   }
   notification_email_from mysql@qq.com
   smtp_server 127.0.0.1
   smtp_connect_timeout 30
   router_id mysql_ha
}
vrrp_script chk_mysql {
    script "/etc/keepalived/check_slave.sh"
    interval 2
    weight 2
}
vrrp_instance mysql-ha {
    state BACKUP    #   指定Keepalived的角色，MASTER主机 BACKUP备份,此处两个都设置为BACKUP
    interface ens33
    virtual_router_id 68  # 虚拟路由标识，这个标识是一个数字(1-255)，在一个VRRP实例中主备服务器ID必须一样
    # IP 142主机该值设置为 100；IP 147 主机该值设置为 99
    priority 100  # 优先级，数字越大优先级越高，在一个实例中主服务器优先级要高于备服务器
    advert_int 1 #  设置主备之间同步检查的时间间隔单位秒
    nopreempt # 设置不抢占模式,一个主机设置即可
    authentication {    #   设置验证类型和密码
        auth_type PASS
        auth_pass centos    # 设置验证密码，在一个实例中主备密码保持一样
    }
    track_script {
        chk_mysql  # 执行监控的服务
    }
    virtual_ipaddress { # 定义虚拟IP地址,可以有多个，每行一个
        192.168.96.166
    }
}
EOF

# 3, 生成检查脚本
# 两个主机都需要生成，应用之前，需要替换对应的 IP 值
# ？如何保证不丢失MySQL执行语句
cat >  /etc/keepalived/check_slave.sh <<'EOF'
#!/bin/bash
#This scripts is check for Mysql Slave status
counter=$(netstat -na|grep "LISTEN"|grep "3306"|wc -l)
if [ "${counter}" -eq 0 ]; then
    systemctl stop keepalived
fi
ping 192.168.96.147 -w1 -c1 &>/dev/null
# 解决脑裂
# /sbin/arping -I eth0(network card) -c 3 -s 192.168.96.147(source ip) 192.168.96.254(gateway)
if [ $? -ne 0 ]
then
    systemctl stop keepalived
fi
EOF
chmod +x /etc/keepalived/check_slave.sh


# 4， 启动服务
systemctl start keepalived
systemctl enable keepalived


# 5, 测试
在有 ip a 显示到 166 的主机上停止 mysql 服务，查看 vip 是否有漂移。
```

## 4,主从同步不一致的问题

比如 slave 同步 master 的日志文件已经发生变更了。
这个时候需要停止slave的同步进程，然后查看Master的binlog信息，并更新到slave，然后重启slave。

```
为了防止数据不一致可以
# 在主库锁表防止写入
flush tables with read lock;
# mysqldump 进行逻辑备份后：
unlock tables;
```

具体操作流程：

```
# 1，从库停止同步
stop slave;
# 2,主库刷新日志
flush logs;
# 3,主库查看状态
show master status;
# 4,从库修改状态值(替换对应的值)
CHANGE MASTER TO MASTER_LOG_FILE='master-bin.000005',MASTER_LOG_POS=154;
# 5，从库启动同步
start slave;
# 6，从库查看状态
show slave status \G;
```



## 5，附录
错误提示1： error_code 1593
原因：MySQL Server 配置文件 server-id 一致导致，具体表现为数据目录中的 auto.cnf 值一致

其它问题排除思路有网络、防火墙、Selinux等。

