---
layout: post
title: Docker offline usage
tags: [Docker]
categories:
- blog
---

## Note  
---

##### ENV: Docer service

####Target

​   The scene used for network unaccessable.



####For image

```
# docker pull  gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.7
# docker save  gcr.io/google_containers/k8s-dns-sidecar-amd64 > k8s-dns-sidecar-amd64-1.14.7.tar
```

####For container

```
# docker ps |grep nginx
92d9712e1659        nginx:latest           "nginx -g 'daemon ..."   2 weeks ago         Up 6 minutes        0.0.0.0:6789->80/tcp                       nginxwww_nginx-www_1
# docker commit  92d9712e1659 nginx-http
->sha256:c58f72eedd6c4ab63f79caf82db706f8ef0888ac289000c4f0f57c9066c72d4b
# docker save nginx-http > nginx-http.tar
```



####Load images

The same method.

```
docker load < k8s-dns-sidecar-amd64-1.14.7.tar
docker load < nginx-http.tar
```

---
end
