# Linux常用的基础命令

### linux文件系统规则

1. 文件名名称严格区分大小写
2. 文件名可使用除"/"外的所有字符，不推荐用特殊字符，推荐用_连接
3. 长度不能超过255字符
4. 以.开头的文件为隐藏文件
5. .表示当前目录， ..表示当前目录的上一级目录
6. 工作目录working directory 为当前目录，用.表示，使用pwd命令查询
7. 家目录：home directory为用户登录后的默认管理目录，管理员家目录为/root，普通用户家目录为/home/用户名，用~表示，直接cd可进入，管理员使用cd ~用户名可到其他用户家目录

### pwd 显示工作目录（当前目录）

- printing working directory

```
[root@localhost ~]# pwd
/root
```

### cd 切换目录

- change directory
- 用法：cd: cd [-L|-P] [dir]
- cd 不加参数为切换到家目录，= cd ~

```
[root@localhost ~]# cd /etc/
[root@localhost etc]# cd
[root@localhost ~]# pwd
/root
```

- cd ~用户名 管理员可以到指定用户的家目录

```
[root@localhost ~]# cd /etc
[root@localhost etc]# cd ~root
```

- cd - 在上一次目录和当前目录来回切换

```
[root@localhost ~]# cd -
/etc
[root@localhost etc]# cd -
/root
```

- 由OLDPWD和PWD环境变量记录位置

```
[root@localhost ~]# echo $PWD
/root
[root@localhost ~]# echo $OLDPWD
/etc
```

- cd .. 返回上一级目录
- cd ./audit 进入当前目录的子目录  

```
[root@localhost ~]# cd ..
[root@localhost /]# cd ./etc/
[root@localhost etc]# pwd
/etc
```

### ls 列出指定目录下的内容

- list
- ls用法：ls [OPTION]... [FILE]...
- ls 省略参数，查看当前目录，，默认以文件名字母表顺序排列

```
[root@localhost ~]# ls
anaconda-ks.cfg install.log install.log.syslog
```

- ls -a 显示所有文件包括隐藏文件(all)
```
[root@localhost ~]# ls
anaconda-ks.cfg
[root@localhost ~]# ls -a
. anaconda-ks.cfg .bash_logout .bashrc .tcshrc
.. .bash_history .bash_profile .cshrc
```

- ls -A 显示除了,和..的所有文件

```
[root@localhost ~]# ls -A
anaconda-ks.cfg .bash_logout .bashrc install.log .lesshst
.bash_history .bash_profile .cshrc install.log.syslog .tcshrc
```

- ls -l 长格式显示文件的详细属性信息

```
[root@localhost ~]# ls -l
total 20
-rw-------. 1 root root 956 May 10 09:03 anaconda-ks.cfg
-rw-r--r--. 1 root root 9617 May 10 09:03 install.log
-rw-r--r--. 1 root root 3161 May 10 09:01 install.log.syslog
```

- 第一列是11位
  1. 文件类型（文件是-，目录是d，还有b c l s p）
  2. rw-：属主权限
  3. r--：属组权限
  4. r--：其他用户权限
  5. . : selinux（.）和acl（+）相关权限

- 第二列是文件被硬链接的次数
- 第三列是属主
- 第四列是属组
- 第五列是文件大小，Bytes单位
- ls -lh （human-readble人类可读，则有KB MB等单位，但不精确）

```
[root@localhost ~]# ls -lh
total 20K
-rw-r--r-- 1 root root 0 May 12 02:31 abc
-rw-------. 1 root root 956 May 10 09:03 anaconda-ks.cfg
-rw-r--r--. 1 root root 9.4K May 10 09:03 install.log
-rw-r--r--. 1 root root 3.1K May 10 09:01 install.log.syslog
```

- 第六到第八列是文件最近一次被修改的日期（mtime） （月 日 时:分）
- 第九列是文件名

- ls -ld 查看目录的属性(directory)

```
[root@localhost ~]# ls -ld /root/
dr-xr-x---. 2 root root 4096 May 12 02:31 /root/
```

- ls -r  逆序查看（字母表逆序） reverse

```
[root@localhost ~]# ls -lr
total 20
-rw-r--r--. 1 root root 3161 May 10 09:01 install.log.syslog
-rw-r--r--. 1 root root 9617 May 10 09:03 install.log
-rw-------. 1 root root 956 May 10 09:03 anaconda-ks.cfg
-rw-r--r-- 1 root root 0 May 12 02:31 abc
```

- ls -R 递归查看 recursive
```
[root@localhost ~]# ls -R /etc
```

- ls -lt 按时间顺序查看（最新的文件在最上面）

```
[root@localhost ~]# ls -lt
total 20
-rw-r--r-- 1 root root 0 May 12 02:31 abc
-rw-------. 1 root root 956 May 10 09:03 anaconda-ks.cfg
-rw-r--r--. 1 root root 9617 May 10 09:03 install.log
-rw-r--r--. 1 root root 3161 May 10 09:01 install.log.syslog
```

- ls -ltr 按时间顺序逆序查看（最新的文件在最下面）

```
[root@localhost ~]# ls -ltr
total 20
-rw-r--r--. 1 root root 3161 May 10 09:01 install.log.syslog
-rw-r--r--. 1 root root 9617 May 10 09:03 install.log
-rw-------. 1 root root 956 May 10 09:03 anaconda-ks.cfg
-rw-r--r-- 1 root root 0 May 12 02:31 abc
```

### cat 文本查看工具，连接文件，显示到标准输出上

- 不要使用cat查看二进制文件
- 参数接多个文件，合并显示

```
[root@localhost ~]# echo "Hello" >> abc
[root@localhost ~]# echo "world" >> 123
[root@localhost ~]# cat abc
Hello
[root@localhost ~]# cat 123
world
[root@localhost ~]# cat abc 123
Hello
world
```

- -n 显示行号，查看两个文件同意编号
```
[root@localhost ~]# cat -n abc 123
     1 Hello
     2 world
```

- -E 显示结束符$
```
[root@localhost ~]# cat -E abc 123
Hello$
world$
```

### tac 文本文件查看工具，文件内容逆序显示

```
[root@localhost ~]# tac /etc/passwd
```

### file 查看文件内容的类型

```
[root@localhost ~]# file /etc/passwd
/etc/passwd: ASCII text
```

### echo 回显命令

- 用法：       echo [SHORT-OPTION]... [STRING]...

```
[root@localhost ~]# echo "Hello world"
Hello world
```

- echo -n 不换行输出

```
[root@localhost ~]# echo -n "Hello World"
Hello World[root@localhost ~]#
```

- echo -e 让转义符生效（\n换行 \t横向制表符）

```
[root@localhost ~]# echo -e "Hello\nWorld"
Hello
World
```

- 显示红色字

```
[root@localhost ~]# echo -e "\033[31m helloworld \033[0m"
 helloworld
```

- "Hello$SHELL" 双引号为弱引用，会变量替换$SHELL标准写法${SHELL}
- 'Hello$SHELL' 单引号为强引用，不做变量替换

```
[root@localhost ~]# echo "hello${SHELL}world"
hello/bin/bashworld
[root@localhost ~]# echo 'hello${SHELL}world'
hello${SHELL}world
```

### shutdown 关机命令
- 用法 shutdown [OPTIONS...] [TIME] [WALL...]
- shutdown -h 关机
- -h now立即关机

```
[root@localhost ~]# shutdown -h now
```

- TIME可以接now hh:mm +m
- -r 重启

```
[root@localhost ~]# shutdown -r +5
Shutdown scheduled for Sat 2018-05-12 11:28:38 CST, use 'shutdown -c' to cancel.
[root@localhost ~]#
Broadcast message from root@localhost.localdomain (Sat 2018-05-12 11:23:38 CST):
The system is going down for reboot at Sat 2018-05-12 11:28:38 CST!
```

+ -c 取消关机或重启
```
[root@localhost ~]# shutdown -c
Broadcast message from root@localhost.localdomain (Sat 2018-05-12 11:24:10 CST):
The system shutdown has been cancelled at Sat 2018-05-12 11:25:10 CST!
```

- WALL为给所有终端发送的信息

```
[root@localhost ~]# shutdown -c "Hello World"
[root@localhost ~]#
Broadcast message from root@localhost.localdomain (Sat 2018-05-12 11:25:12 CST):
Hello World
The system shutdown has been cancelled at Sat 2018-05-12 11:26:12 CST!
```

### date 日期显示与设置

- 用法：
       - 显示：date [OPTION]... [+FORMAT]
       - 设置：date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
- 显示

```
%F：%Y-%m-%d
[root@localhost ~]# date +%F
2018-05-12
%T：%H:%M:%S
[root@localhost ~]# date +%T
11:27:21
[root@localhost ~]# date +%F-%H-%M-%S
2018-05-12-11-28-55
%s：时间戳，从1970年1月1日零时零分零秒开始的秒数
[root@localhost ~]# date +%s
1526095780
%Z %z：时区
[root@localhost ~]# date +"%Z %z"
CST +0800

```

- 设置 date 月日小时分钟年.秒，年可以4位，也可以2位，年和秒可以省略

```
[root@localhost ~]# date 051211312018.35
Sat May 12 11:31:35 CST 2018
```

### hwclock(clock是软链接) 查询和设定硬件时钟

- 主板上电池给硬件时钟供电，内核启动时从硬件时钟读取时间信息，之后系统时间根据内核的频率计时，不与硬件时钟关联
- hwclock 查看硬件时间
- hwclock要与hwclock --localtime一致 7上要设置为

```
timedatectl set-local-rtc 1 # 将硬件时钟调整为与本地时钟一致, 0 为设置为 UTC 时间
timedatectl set-timezone Asia/Shanghai # 设置系统时区为上海
[root@localhost ~]# hwclock
Sat 12 May 2018 03:36:12 AM CST -0.755907 seconds

```

- hwclock -s 两个时间同步，以硬件时间为准
- hwclock -w 两个时间同步，以系统时间为准

```

[root@localhost ~]# hwclock -w
```

### cal 当月日历

- 用法：cal [options] [[[day] month] year]
- cal 不加为当前
- cal可接 日 月 年

```
[root@localhost ~]# cal
      May 2018
Su Mo Tu We Th Fr Sa
       1 2 3 4 5
 6 7 8 9 10 11 12
13 14 15 16 17 18 19
20 21 22 23 24 25 26
27 28 29 30 31
[root@localhost ~]# cal 11 2018
    November 2018
Su Mo Tu We Th Fr Sa
             1 2 3
 4 5 6 7 8 9 10
11 12 13 14 15 16 17
18 19 20 21 22 23 24
25 26 27 28 29 30
```

### which 查看外部命令路径

```
[root@localhost ~]# which pwd
/bin/pwd
```

### whereis 查看外部命令路径和man手册路径

```
[root@localhost ~]# whereis which
which: /usr/bin/which /usr/share/man/man1/which.1.gz
```

- -b选项，只找二进制文件

```
[root@localhost ~]# whereis -b ls
ls: /bin/ls
```

### who查看当前登录的用户

```
[root@localhost ~]# who
root pts/0 2018-05-12 14:29 (192.168.1.103)
```

### w查看正在登录的用户的详细信息

```
[root@localhost ~]# w
 14:36:49 up 4:07, 2 users, load average: 0.00, 0.01, 0.05
USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
root pts/0 192.168.1.103 14:35 1.00s 0.04s 0.01s w
```


