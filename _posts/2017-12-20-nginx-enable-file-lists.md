---
layout: post
title: Nginx Enable files list
tags: []
categories:
- blog
---
 Nginx Enable FILES lists

二级目录 /files 开启文件列表显示,访问方式为 http://site.com/files/
alias 声明虚拟目录

解释
```
location /files/ {                                                                                                                                                        
	alias /usr/share/nginx/html/downloads/;
	@ alias 声明虚拟目录
	@ alias目录必须要以 / 结尾且alias只能在location中使用
	autoindex on;
	@ 启用目录浏览
	autoindex_exact_size off;
	@ 显示出文件的大概大小，单位是kB或者MB或者GB；否则是 bytes
	autoindex_localtime on;
	@ 显示的文件时间为文件的服务器时间; 否则是 GMT 时间
	default_type application/octet-stream;
	@ Nginx也没找到对应文件的扩展名的话，就使用默认的Type

}   
```

例子
```
    location /files/ {                                                                                                                                                        
        alias /usr/share/nginx/html/downloads/;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        default_type application/octet-stream;
    }   
```


