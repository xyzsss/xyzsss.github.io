---
layout: post
title: command line proxy
tags: [proxy, command line]
categories:
- blog
---

## Note  
---

##### ENV:linux/unix


0, Check the public ip first:
    
```
curl icanhazip.com
```

2, Enable proxy with commands below:

```
export http_proxy="http://proxy.exyum.com:7777/"
export https_proxy="http://proxy.exyum.com:7777/"
export no_proxy="host1,localhost"
```

3, Check proxyable
```
curl icanhazip.com
```

4, suggestion:
add it to `~/.bashrc` file

```
function enable-proxy(){
    /usr/bin/curl icanhazip.com
    export http_proxy="http://proxy.exyum.com:7777/";
    export https_proxy="http://proxy.exyum.com:7777/";
    export no_proxy="host1,localhost"
    /usr/bin/curl icanhazip.com
}

function disable-proxy(){
    /usr/bin/curl icanhazip.com
    unset http_proxy
    unset https_proxy
    /usr/bin/curl icanhazip.com
}
```

Then ,use it `enable-proxy` to enable it and `disable-proxy` to disable it.
---
end
