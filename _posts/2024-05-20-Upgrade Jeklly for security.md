---
layout: post
title: Jekyll upgrade
tags: [daily]
categories:
- blog
---

## Jekyll upgrade for Dependabot alerts  
---

##### Jekyll


- Ruby
- sudo gem install jekyll
ERROR:  Error installing jekyll:
	The last version of rouge (>= 3.0, < 5.0) to support your Ruby & RubyGems was 3.30.0. Try installing it with `gem install rouge -v 3.30.0` and then running the current command again
	rouge requires Ruby version >= 2.7. The current ruby version is 2.6.3.62.
- sudo gem install rouge -v 3.30.0
- brew install ruby@2.7

---

```
brew install chruby ruby-install
ruby-install ruby
ruby -v
ruby-install 3.1.2 -- --enable-shared
    
```
 ! Mac  安装 ruby 3 太难了。。。


### Centos

```
# centos 7.9
sudo yum install epel-release -y
sudo yum install centos-release-scl -y
sudo yum install gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-develop make bzip2 autoconf automake libtool bison iconv-devel sqlite-devel ncurses-devel gdbm-devel -y
<!-- gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB -->
curl -L https://get.rvm.io | bash -s stable
gpg2 --keyserver hkp://keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -L https://get.rvm.io | bash -s stable
source /etc/profile.d/rvm.sh


rvm install 3.1.2
rvm use 3.1.2 --default


gem install bundler jekyll

git clone git@github.com:xyzsss/xyzsss.github.io.git
cd xyzsss.github.io/
bundle install
bundle update activesupport
bundle update kramdown
git push
```
Work fine!!!

---
