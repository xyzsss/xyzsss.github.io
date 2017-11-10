---
layout: post
title: Docker CE Installation
tags: [Docker, CentOS7, Installation]
categories:
- blog
---

#### ENV
    `CentOS 7`  
---


Since the Docker 1.13 version released about Feb in 2017 ,the Docker divide into CE Version and EE Version,It was free the fist,Then the next was enhanced in security.

#### 0, System update  

Update before:

    [root@OM-T ~]# cat /proc/version 
    Linux version 3.10.0-693.el7.x86_64 (builder@kbuilder.dev.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) ) #1 SMP Tue Aug 22 21:09:27 UTC 2017
    [root@OM-T ~]# docker -v
    Docker version 1.12.6, build 0fdc778/1.12.6

Update OS system：

    yum update -y  

Updated:

    [root@OM-T ~]# cat /proc/version
    Linux version 3.10.0-693.5.2.el7.x86_64 (builder@kbuilder.dev.centos.org) (gcc version 4.8.5 20150623 (Red Hat 4.8.5-16) (GCC) ) #1 SMP Fri Oct 20 20:32:50 UTC 2017
    [root@OM-T ~]#  docker -v
    Docker version 17.07.0-ce, build 8784753
    [root@OM-T ~]# cat /etc/redhat-release 
    CentOS Linux release 7.4.1708 (Core)


#### 1, Remove docker version if existing

    yum remove docker docker-common docker-selinux docker-engine

#### 2, Add aliyun docker yum rresponsity 

    yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

#### 3, Cache yum repo

    yum-config-manager --enable docker-ce-edge
    yum makecache fast

#### 4, Install docker-ce

    yum install docker-ce

#### 5, Start docker-ce service and enable it when sys start

    systemctl enable docker
    systemctl start docker

#### 6, Check docker installation

    # docker -v
    Docker version 17.07.0-ce, build 8784753
    # docker info
    Containers: 53
     Running: 11
     Paused: 0
     Stopped: 42
    Images: 85
    Server Version: 17.07.0-ce
    ... 

#### 7, Issue ref
If occur message when you remove the images or container after docker-ce installation like `Error response from daemon: reference does not exist` ,you just rollback the docker version before ,then reinstall docker-ce.