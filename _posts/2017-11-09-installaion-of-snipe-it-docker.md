---
layout: post
title: installation of Open source asset management system snipe-it 
tags: [snipe-it, Docker, Installation]
categories:
- blog
---

Project URL: https://github.com/snipe/snipe-it
Page REF: https://snipe-it.readme.io/docs/docker

###### ENV
	CentOS 7.1
	docker 

The version of snipe-it is 4.0.15,which is the newest now.


#### 0,Pull snipe-it docker image,specific version can be used here:

	docker pull snipe/snipe-it


#### 1, Generate the snipe-it app key:

	docker run --rm snipe-it
  
#### 2,  Create configuration file `my_env_file` to generate mysql-container container.

	# filenale: my_env_file
	# Mysql Parameters
	MYSQL_ROOT_PASSWORD=YOUR_WANTED_PASSWORD
	MYSQL_DATABASE=snipeit
	MYSQL_USER=snipeit
	MYSQL_PASSWORD=YOUR_WANTED_PASSWORD

	# Email Parameters
	MAIL_PORT_587_TCP_ADDR=smtp.qq.com
	MAIL_PORT_587_TCP_PORT=587
	MAIL_ENV_FROM_ADDR=notify@xxxxx.com
	MAIL_ENV_FROM_NAME=notify@xxxxx.com
	# - pick 'tls' for SMTP-over-SSL, 'tcp' for unencrypted
	MAIL_ENV_ENCRYPTION=tcp
	MAIL_ENV_USERNAME=notify@xxxxx.com
	MAIL_ENV_PASSWORD=xxxxxxxxxx

	# Snipe-IT Settings
	APP_ENV=production
	APP_DEBUG=false
	APP_KEY=base64:Wj8a/HJfcWu5FxsVtr9rraImf7B6JkQWuVp2nhahPgI=
	APP_URL=http://127.0.0.1:80
	APP_TIMEZONE=Asia/Shanghai
	APP_LOCALE=zh-CN



#### 3, Generate the container with configration file `my_env_file`  

	docker run --name snipe-mysql --env-file=my_env_file -d -p 3306:3306 mysql:5.6

	Explaination:
		d, 成功启动容器后输出容器的完整ID
		p, 端口映射
		e, 配置信息  

#### 4, Start snipeit service  
	
	mkdir -p /data/snipeit
	docker run -d -p 80:80 -p 443:443 --name="snipeit" --link snipe-mysql:mysql -v /data/snipeit:/var/lib/snipeit --env-file=my_env_file snipe-it

	Use "/data/snipeit" to store data,port 80 for http and 443 for https.

#### 5，Test snipe-it

	Visit http://IP with broswer.
