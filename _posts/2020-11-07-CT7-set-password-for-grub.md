---
layout: post
title: CentOS 7 为 grub 设置密码
tags: [grub]
categories:
- blog
---


## 0, 背景
使用 grub2-mkpasswd-pbkdf2  生成加密后的密码配置到 grub 的用户文件，配置完使用 grub2-mkconfig 重新生成grub配置。

## 1，备份

```
cp /boot/grub2/grub.cfg /boot/grub2/grub.cfg.bak
```

## 2，密文内容

```
# 生成密文（生成的 grub.xxxx 值添加到下面的配置文件中）
grub2-mkpasswd-pbkdf2
cat >> /etc/grub.d/01_users<<EOF
set superusers="r oot"
password_pbkdf2 root grub.xxxx
EOF
```

## 3，重新生成 grub

```
grub2-mkconfig -o /boot/grub2/grub.cfg
# 如果是以UEFI启动方式,重新生成 UEFI
# grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg
```





