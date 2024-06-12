---
layout: post
title: Gem change source
tags: [daily]
categories:
- blog
---

## Ruby 镜像源  
---

#####  修改方式

1，命令行修改


```
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
# gem sources --add https://gems.ruby-china.com/
# gem sources --remove https://rubygems.org/
gem sources --clear-all
gem sources --update
# test source
gem sources -l
```

2，手动修改

Gemfile
```
# default
source "https://rubygems.org"
# china
source "https://gems.ruby-china.com/"
```


---
