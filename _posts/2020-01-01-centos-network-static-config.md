---
layout: post
title: centos 网络网卡配置文件参考
tags: [centos]
categories:
- blog
---

## CentOS 静态网络配置文件参考


## 背景
Archive

## 内容

栗子

```
test -s /etc/sysconfig/network-scripts/ifcfg-ens33 && cp /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33.bak
cat > /etc/sysconfig/network-scripts/ifcfg-ens33<<EOF
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=ens33
DEVICE=ens33
ONBOOT=yes              # 开机自启
BOOTPROTO=static        # 类型
IPADDR=192.168.96.138   # 设置IP地址
PREFIX=24               # 设置子网掩码
GATEWAY=192.168.96.1    # 设置网关
DNS1=192.168.96.2       # 设置主DNS
DNS2=223.6.6.6          # 设置备DNS
EOF
```

重启网络并查看ip是否生效

```
systemctl restart network
ip addr
```
