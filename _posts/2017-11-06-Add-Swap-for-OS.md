---
layout: post
title: Add swap for OS
tags: [swap, OS, configuration]
categories:
- blog
---

## Note  
---

##### ENV: CentOS 6


0, Check swap status

    swapon -s 

1, Check file system

    df

2, Create and Enable Swap file
    The filesize of swap space is 2048k(2GB).

    dd if=/dev/zero of=/swapfile bs=1024 count=2048k
    mkswap /swapfile
    swapon /swapfile

3, Make it effect when sys reboot

    echo "/swapfile          swap            swap    defaults        0 0" >> /etc/fstab
    chown root:root /swapfile 
    chmod 0600 /swapfile

4, Check swap space status

    swapon -s  
or  

    free -m  

4, Adjust for system

    cat /proc/sys/vm/swappiness  

a value from 0 to 100,if comes to 100,it means system use swap often and usually, too soon.
RAM is much faster than swap space.  

If needed , it can changed by:

    sysctl vm.swappiness=10

Or change it permanently:

    echo "vm.swappiness=10" >> /etc/sysctl.conf

5, Others
    
    df -Thi  
Count partition inode usage.

    find / -xdev -printf '%h\n' | sort | uniq -c | sort -k 1 -n  
inode useage count.

---
end
