---
layout: post
title: Build docker private registry
tags: [registry, docker]
categories:
- blog
---

## Note  
---

##### ENV:CentOS 7 with docker


####0, pull image named registry first:
    
```
docker pull registry
```

####2, Runnging the container with images:

New data dir for registry.  
```
mkdir -p /data/storage/registry
```

Here, changed the default port 5000 to 5555 in case to port conflict.   

```
docker run -d -p 5555:5000 --restart=always -v /data/storage/registry:/var/lib/registry --name registry registry
```

####3, Check container
```
netstat -ntpl|grep 5555
docker ps|grep registry
```

####4, Usage

Push public image to private registry.
##### 4.1 pull image fisrt

```
docker pull ubuntu
```     
##### 4.2 get image id and tag it
```
docker images|grep ubuntu
docker tag ubuntu HOST_IP:5555/ubuntu;v.1
```

##### 4.3 push the tagged image 
```
docker push localhost:5555/myfirstimage
```

##### 4.4  verify the image 
```
docker pull HOST_IP:5555/myfirstimage
```

#### 5, Use private http docker registry
Enable it with non-http access,please relace `HOST_IP` with approviate value.

```
sed -i 's;^ExecStart.*;ExecStart=/usr/bin/dockerd --insecure-registry HOST_IP:5555;' /usr/lib/systemd/system/docker.service && \
systemctl daemon-reload && \
systemctl restart docker
```

end