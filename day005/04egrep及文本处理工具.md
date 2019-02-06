# egrep及文本处理工具

### grep egrep fgrep

- grep = grep -G 基本正则
- egrep = grep -E 扩展正则
- fgrep = grep -F 不用正则

### grep -E 与 grep 异同

1. 字符匹配相同
2. 次数匹配去掉\
3. 位置锚定相同
4. 分组去掉\，引用相同
5. 或 | 如 Cat|cat (C|c)at

```
[root@localhost ~]# ifconfig eth0|grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}"
192.168.1.108
192.168.1.255
255.255.255.0
[root@localhost ~]# grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" /var/log/secure
0.0.0.0
0.0.0.0
0.0.0.0
192.168.1.103
192.168.1.103
192.168.1.103
192.168.1.103
[root@localhost ~]# grep -Ev "^$|^#" /etc/fstab
UUID=b8383511-7dd4-4ca8-97ec-aa9cf6c7891a / ext4 defaults 1 1
UUID=27f92270-8e98-45fa-a2d1-9a02aac91de3 /boot ext4 defaults 1 2
UUID=6222be03-698a-4f3c-adcc-8d572ba7e178 swap swap defaults 0 0
tmpfs /dev/shm tmpfs defaults 0 0
devpts /dev/pts devpts gid=5,mode=620 0 0
sysfs /sys sysfs defaults 0 0
proc /proc proc defaults 0 0
```

### 文本查看及处理工具

#### wc （word count） 单词统计

- wc 会显示 行数 单词数 字节数
- wc -l 显示行
- wc -w 显示单词
- wc -c 显示字节
- wc -m 显示字符

```
[root@localhost ~]# wc -l /etc/fstab
15 /etc/fstab
[root@localhost ~]# wc /etc/fstab
 15 78 805 /etc/fstab
[root@localhost ~]# wc -w !$
wc -w /etc/fstab
78 /etc/fstab
[root@localhost ~]# wc -c !$
wc -c /etc/fstab
805 /etc/fstab
[root@localhost ~]# wc -m !$
wc -m /etc/fstab
805 /etc/fstab
```

#### cut 切片

- -d delimiter 分隔符
- -f  fields 字段  ,离散 -连续

```
[root@localhost ~]# cut -d: -f1,7 /etc/passwd
root:/bin/bash
bin:/sbin/nologin
daemon:/sbin/nologin
adm:/sbin/nologin
lp:/sbin/nologin
sync:/bin/sync
shutdown:/sbin/shutdown
halt:/sbin/halt
mail:/sbin/nologin
uucp:/sbin/nologin
operator:/sbin/nologin
games:/sbin/nologin
gopher:/sbin/nologin
ftp:/sbin/nologin
nobody:/sbin/nologin
vcsa:/sbin/nologin
saslauth:/sbin/nologin
postfix:/sbin/nologin
sshd:/sbin/nologin
```

#### sort 排序

- 默认ascii表，从最左侧升序排序
- -t separator 分隔符
- -k key 字段
- -n 基于数值大小排序
- -r 逆序
- -f 忽略大小写
- -u 重复行只统计一行

```
[root@localhost ~]# sort -nr -t: -k3 /etc/passwd
saslauth:x:499:76:Saslauthd user:/var/empty/saslauth:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
vcsa:x:69:69:virtual console memory owner:/dev:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
gopher:x:13:30:gopher:/var/gopher:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
uucp:x:10:14:uucp:/var/spool/uucp:/sbin/nologin
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
halt:x:7:0:halt:/sbin:/sbin/halt
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
sync:x:5:0:sync:/sbin:/bin/sync
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
bin:x:1:1:bin:/bin:/sbin/nologin
root:x:0:0:root:/root:/bin/bash
[root@localhost ~]# cut -d: -f7 /etc/passwd|sort -u
/bin/bash
/bin/sync
/sbin/halt
/sbin/nologin
/sbin/shutdown
```

#### uniq 重复行只保留一份，先sort 后 uniq

- uniq -c 显示重复行出现的次数
- uniq -u 只显示唯一行
- uniq -d 只显示非唯一行
```
[root@localhost ~]# cut -d: -f7 /etc/passwd|sort|uniq -c
      1 /bin/bash
      1 /bin/sync
      1 /sbin/halt
     15 /sbin/nologin
      1 /sbin/shutdown
```

#### diff 比较两个文件的异同

- -u 显示默认3行的上下文
- diff fstab fstab.new > fstab_patch

```
[root@localhost tmp]# diff fstab fstab.new
2c2
< #
---
> # comment
[root@localhost tmp]# diff -u fstab fstab.new
--- fstab 2018-05-25 11:27:34.916005283 +0800
+++ fstab.new 2018-05-25 11:28:09.883999514 +0800
@@ -1,5 +1,5 @@
-#
+# comment
 # /etc/fstab
 # Created by anaconda on Thu May 10 08:52:13 2018
 #
```

#### patch 打补丁与还原

- -i 指定补丁名 
- -R 还原
- 最小化需要安装 yum -y install patch

```
[root@localhost tmp]# yum -y install patch
[root@localhost tmp]# diff fstab fstab.new > fstab.patch
[root@localhost tmp]# patch -i fstab.patch fstab
patching file fstab
[root@localhost tmp]# diff fstab fstab.new
[root@localhost tmp]# patch -R -i fstab.patch fstab
patching file fstab
[root@localhost tmp]# diff fstab fstab.new
2c2
< #
---
> # comment
```

