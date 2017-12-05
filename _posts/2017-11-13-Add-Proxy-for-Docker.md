---
layout: post
title: Add Proxy for Docker
tags: [Dcoker, Proxy]
categories:
- blog
---

## Note  
---

##### ENV: Docker on CentOS 7


1, Target

Make it can pull google docker image.
By default Kubernetes looks in the public Docker registry to find images。


2, Create and Enable Swap file
    The filesize of swap space is 2048k(2GB).

    dd if=/dev/zero of=/swapfile bs=1024 count=2048k
    mkswap /swapfile
    swapon /swapfile

3, Make it as scripts

```
#!/bin/bash
# enable-docker-proxy
# ENV: CentOS 7

mkdir -p /etc/systemd/system/docker.service.d
echo "[Service]" >> /etc/systemd/system/docker.service.d/http-proxy.conf
echo "Environment='HTTP_PROXY=http://proxy.exyum.com:7777/'" >> /etc/systemd/system/docker.service.d/http-proxy.conf
# FOR HTTPS: Environment="HTTPS_PROXY=https://proxy.example.com:443/";
# FOR REGISTRY: Environment="HTTP_PROXY=http://proxy.example.com:80/"; "NO_PROXY=localhost,127.0.0.1,docker-registry.somecorporation.com"
systemctl daemon-reload
systemctl restart docker
systemctl show --property=Environment docker
```

4, Enable it on `~/.bashrc` file

```
function enable-docker-proxy(){
    mkdir -p /etc/systemd/system/docker.service.d
    echo "[Service]" >> /etc/systemd/system/docker.service.d/http-proxy.conf
    echo "Environment='HTTP_PROXY=http://proxy.example.com:7777/'" >> /etc/systemd/system/docker.service.d/http-proxy.conf
    systemctl daemon-reload
    systemctl restart docker
    systemctl show --property=Environment docker
}

function disable-docker-proxy(){
    rm -f /etc/systemd/system/docker.service.d/http-proxy.conf
        systemctl daemon-reload
        systemctl restart docker
        systemctl show --property=Environment docker
}
```

then use `enable-docker-proxy` to enable proxy,vice.



---
end
