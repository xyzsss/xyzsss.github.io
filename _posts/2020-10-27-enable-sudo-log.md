---
layout: post
title: sudo 配置日志记录
tags: [centos, log]
categories:
- blog
---

## Note  
---

## 配置 sudo 命令记录到 /var/log/sudo.log 

## 背景

    归档记录，审计，回溯。

## 内容

```
- 创建sudo日志文件 /var/log/sudo.log

- 配置 sudoer 
    /etc/sudoers 配置新增：
        Defaults logfile=/var/log/sudo.log
        Defaults loglinelen=0
        Defaults !syslog
- 在 rsyslog 配置 sudo 
   /etc/rsyslog.conf 配置新增： 
        local2.debug /var/log/sudo.log
   重启 rsyslog：
        systemctl restart rsyslog
```

## 脚本

```
test -e /var/log/sudo.log  && echo "sudo.log已创建" || ( touch /var/log/sudo.log && echo "新建 /var/log/sudo.log 日志文件")
egrep -q "/var/log/sudo.log" /etc/rsyslog.conf  && echo "sudo.log 已经配置到 rsyslog.conf,跳过" ||  (echo "local2.debug /var/log/sudo.log" >> /etc/rsyslog.conf && echo "新增 sudo.log 到 rsyslog.conf")
(egrep -q "Defaults logfile=/var/log/sudo.log" /etc/sudoers || egrep -q 'Defaults !syslog' /etc/sudoers) && echo "sudoers文件已经配置" || \
( echo "Defaults logfile=/var/log/sudo.log" >> /etc/sudoers && echo "Defaults loglinelen=0" >> /etc/sudoers && echo 'Defaults !syslog' >> /etc/sudoers && echo "新增配置到sudoers" \
&& ( systemctl restart rsyslog && echo "rsyslog服务已重启,sudo操作审计已开启" || echo "rsyslog重启失败") )
```
