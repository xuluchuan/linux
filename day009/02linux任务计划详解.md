# linux任务计划详解

- 未来时间点一次运行 at batch
- 周期运行 crontab
- 执行结果：通过邮件发送给用户
- 邮箱地址：/var/spool/mail/USERNAME
- 邮件服务：netstat -tnl|grep 25 centos5 sendmail centos6 7 postfix 本地邮件服务
- 邮件服务发送协议：smtp：simple mail transmission protocol 简单邮件传输协议
- 邮件服务接收协议：pop3：post office protocol 邮局协议 IMAP4：internet mail access protocol 互联网邮件接收协议
+邮件用户代理：    MUA mail user agent ：mailx程序，软链接为mail

### mail

- mail [-s 'SUBJECT'] username@hostname
- 编写邮件正文后，最后一行使用.号或ctrl+D退出
- 使用输入重定向 mail -s 'hello' root < FILE
- 使用管道 echo "helloworld" | mail -s 'hello' root
- mail命令直接查看邮件，数字选择，d删除，q退出，d *删除所有邮件
- /etc/mail.rc设置邮件发送人
- 需要安装 yum -y install mailx

```
[root@localhost ~]# mail -s 'Hello' root
hello
.
EOT
[root@localhost ~]# mail -s 'Hello' root < /etc/passwd
[root@localhost ~]# echo "hello world" | mail -s 'hello' root
[root@localhost ~]# mail
Heirloom Mail version 12.5 7/5/10. Type ? for help.
"/var/spool/mail/root": 3 messages 2 new 3 unread
 U 1 root Sat Jun 9 11:11 19/611 "Hello"
>N 2 root Sat Jun 9 11:11 35/1391 "Hello"
 N 3 root Sat Jun 9 11:12 18/605 "hello"
& 2
```

### at

- at [OPTION] ... TIME
- TIME: HH:MM [YYYY-mm-dd]
- 或：noon，midnight，teatime
- 或：HH:MM tomorrow
- 或：now+#UNIT UNIT:minutes hours days
- ctrl+D 提交
- 结果将发送到邮件
- at -f /PATH/TO/SOMEFILE TIME  使用文件任务，不使用用户交互
- at -l 查看任务列表
- at -d 编号：删除对应编号的任务
- at -c 编号：查看指定编号作业内容
- 安装 atd ，启动atd 
- yum -y install at
- service atd start/ systemctl start atd.service
- service atd status/ systemctl status atd.service

```
[root@localhost scripts]# vim echoAt.sh
[root@localhost scripts]# cat echoAt.sh
#!/bin/bash
echo "hello world"
[root@localhost scripts]# at -f /root/scripts/echoAt.sh now+1min
job 2 at Sat Jun 9 11:46:00 2018
[root@localhost scripts]# at -l
2 Sat Jun 9 11:46:00 2018 a root
[root@localhost scripts]# at -l
2 Sat Jun 9 11:46:00 2018 a root
[root@localhost scripts]# at -l
[root@localhost scripts]# mail
Heirloom Mail version 12.5 7/5/10. Type ? for help.
"/var/spool/mail/root": 1 message 1 new
>N 1 root Sat Jun 9 11:46 14/505 "Output from your job "
& 1
Message 1:
From root@localhost.localdomain Sat Jun 9 11:46:00 2018
Return-Path: <root@localhost.localdomain>
X-Original-To: root
Delivered-To: root@localhost.localdomain
Subject: Output from your job 2
To: root@localhost.localdomain
Date: Sat, 9 Jun 2018 11:46:00 +0800 (CST)
From: root@localhost.localdomain (root)
Status: R

hello world

& q
Held 1 message in /var/spool/mail/root
You have mail in /var/spool/mail/root
[root@localhost scripts]# at -f /root/scripts/echoAt.sh now+1min
job 4 at Sat Jun 9 11:49:00 2018
[root@localhost scripts]# at -l
4 Sat Jun 9 11:49:00 2018 a root
[root@localhost scripts]# at -d 4
[root@localhost scripts]# at -l
[root@localhost scripts]# at -f /root/scripts/echoAt.sh now+1min
job 5 at Sat Jun 9 11:49:00 2018
[root@localhost scripts]# at -c 5
#!/bin/sh
# atrun uid=0 gid=0
# mail root 0
umask 22
XDG_SESSION_ID=1; export XDG_SESSION_ID
HOSTNAME=localhost.localdomain; export HOSTNAME
SHELL=/bin/bash; export SHELL
HISTSIZE=1000; export HISTSIZE
SSH_CLIENT=192.168.1.103\ 53797\ 22; export SSH_CLIENT
SSH_TTY=/dev/pts/0; export SSH_TTY
USER=root; export USER
LS_COLORS=rs=0:di=01\;34:ln=01\;36:mh=00:pi=40\;33:so=01\;35:do=01\;35:bd=40\;33\;01:cd=40\;33\;01:or=40\;31\;01:mi=01\;05\;37\;41:su=37\;41:sg=30\;43:ca=30\;41:tw=30\;42:ow=34\;42:st=37\;44:ex=01\;32:\*.tar=01\;31:\*.tgz=01\;31:\*.arc=01\;31:\*.arj=01\;31:\*.taz=01\;31:\*.lha=01\;31:\*.lz4=01\;31:\*.lzh=01\;31:\*.lzma=01\;31:\*.tlz=01\;31:\*.txz=01\;31:\*.tzo=01\;31:\*.t7z=01\;31:\*.zip=01\;31:\*.z=01\;31:\*.Z=01\;31:\*.dz=01\;31:\*.gz=01\;31:\*.lrz=01\;31:\*.lz=01\;31:\*.lzo=01\;31:\*.xz=01\;31:\*.bz2=01\;31:\*.bz=01\;31:\*.tbz=01\;31:\*.tbz2=01\;31:\*.tz=01\;31:\*.deb=01\;31:\*.rpm=01\;31:\*.jar=01\;31:\*.war=01\;31:\*.ear=01\;31:\*.sar=01\;31:\*.rar=01\;31:\*.alz=01\;31:\*.ace=01\;31:\*.zoo=01\;31:\*.cpio=01\;31:\*.7z=01\;31:\*.rz=01\;31:\*.cab=01\;31:\*.jpg=01\;35:\*.jpeg=01\;35:\*.gif=01\;35:\*.bmp=01\;35:\*.pbm=01\;35:\*.pgm=01\;35:\*.ppm=01\;35:\*.tga=01\;35:\*.xbm=01\;35:\*.xpm=01\;35:\*.tif=01\;35:\*.tiff=01\;35:\*.png=01\;35:\*.svg=01\;35:\*.svgz=01\;35:\*.mng=01\;35:\*.pcx=01\;35:\*.mov=01\;35:\*.mpg=01\;35:\*.mpeg=01\;35:\*.m2v=01\;35:\*.mkv=01\;35:\*.webm=01\;35:\*.ogm=01\;35:\*.mp4=01\;35:\*.m4v=01\;35:\*.mp4v=01\;35:\*.vob=01\;35:\*.qt=01\;35:\*.nuv=01\;35:\*.wmv=01\;35:\*.asf=01\;35:\*.rm=01\;35:\*.rmvb=01\;35:\*.flc=01\;35:\*.avi=01\;35:\*.fli=01\;35:\*.flv=01\;35:\*.gl=01\;35:\*.dl=01\;35:\*.xcf=01\;35:\*.xwd=01\;35:\*.yuv=01\;35:\*.cgm=01\;35:\*.emf=01\;35:\*.axv=01\;35:\*.anx=01\;35:\*.ogv=01\;35:\*.ogx=01\;35:\*.aac=01\;36:\*.au=01\;36:\*.flac=01\;36:\*.mid=01\;36:\*.midi=01\;36:\*.mka=01\;36:\*.mp3=01\;36:\*.mpc=01\;36:\*.ogg=01\;36:\*.ra=01\;36:\*.wav=01\;36:\*.axa=01\;36:\*.oga=01\;36:\*.spx=01\;36:\*.xspf=01\;36:; export LS_COLORS
MAIL=/var/spool/mail/root; export MAIL
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin; export PATH
PWD=/root/scripts; export PWD
LANG=en_US.UTF-8; export LANG
HISTCONTROL=ignoredups; export HISTCONTROL
SHLVL=1; export SHLVL
HOME=/root; export HOME
LOGNAME=root; export LOGNAME
SSH_CONNECTION=192.168.1.103\ 53797\ 192.168.1.107\ 22; export SSH_CONNECTION
LESSOPEN=\|\|/usr/bin/lesspipe.sh\ %s; export LESSOPEN
XDG_RUNTIME_DIR=/run/user/0; export XDG_RUNTIME_DIR
OLDPWD=/root; export OLDPWD
cd /root/scripts || {
         echo 'Execution directory inaccessible' >&2
         exit 1
}
${SHELL:-/bin/sh} << 'marcinDELIMITER519a1011'
#!/bin/bash
echo "hello world"

marcinDELIMITER519a1011
```

### batch

- 让系统选择在系统资源空闲的时间执行指定任务

### cron 周期性任务计划

- 服务程序：cronie，守护进程crond daemon 
- systemctl status crond./sercie crond status
- 与atd不同：使用专用配置文件，有固定格式，周期性任务
- cron任务分为：系统cron，用户cron
- 系统cron配置/etc/crontab
- 系统cron特点：时间点（* * * * *） 用户身份 任务命令，需要自定义PATH，执行结果邮件发送给MAILTO指定用户
- 用户cron配置使用命令crontab -e：修改/var/spool/cron/USERNAME文件
- 用户cron特点：时间点 任务命令，需要自定义PATH，执行结果邮件发送给当前用户

### 时间表示法

- 特定值：给定时间内有效取值范围内的值
    + 分（0-59），时（0-23），日（1-31），月（1-12），周（1-7）
    + 周与日不能同时使用
- 通配符：* 给定时间内有效取值范围内的所有值，表示每
- 离散：, 用逗号隔开
- 连续：-
- 指定时间内，定义步长，*/2 每隔两分钟
- 注意：
    1. 指定时间点不能被步长整除，则没有意义
    2. 最小时间单位为分钟，秒级需要借助脚本循环

### crontab命令

- -e：编辑任务，添加#注释可以删除一个任务
- 运行结果以邮件发送给用户，如果不接收需要使用 &> /dev/null
- -l：列出任务
- -r：移除所有任务
- -u ：root为指定用户管理cron
- 定义COMMAND中如果有%，需要转义，或加''
- 某任务在指定时间点因关机未能执行，则下次开机不会自动执行
- 如果需要开机自动执行，需要使用anacron实现
- 脚本前加入 . /etc/profile .~/.bash_profile

```
[root@localhost ~]# crontab -l
* * * * * /bin/bash /root/a.sh
* * * * * /bin/bash /root/b.sh
[root@localhost ~]# cat a.sh
. /etc/profile
. ~/.bash_profile
echo $PATH
[root@localhost ~]# cat b.sh
echo $PATH
[root@localhost ~]# mail
Heirloom Mail version 12.5 7/5/10. Type ? for help.
"/var/spool/mail/root": 2 messages 2 new
>N 1 (Cron Daemon) Sat Jun 9 12:26 25/861 "Cron <root@localhost>"
 N 2 (Cron Daemon) Sat Jun 9 12:26 25/897 "Cron <root@localhost>"
& 1
Message 1:
From root@localhost.localdomain Sat Jun 9 12:26:01 2018
Return-Path: <root@localhost.localdomain>
X-Original-To: root
Delivered-To: root@localhost.localdomain
From: "(Cron Daemon)" <root@localhost.localdomain>
To: root@localhost.localdomain
Subject: Cron <root@localhost> /bin/bash /root/b.sh
Content-Type: text/plain; charset=UTF-8
Auto-Submitted: auto-generated
Precedence: bulk
X-Cron-Env: <XDG_SESSION_ID=44>
X-Cron-Env: <XDG_RUNTIME_DIR=/run/user/0>
X-Cron-Env: <LANG=en_US.UTF-8>
X-Cron-Env: <SHELL=/bin/sh>
X-Cron-Env: <HOME=/root>
X-Cron-Env: <PATH=/usr/bin:/bin>
X-Cron-Env: <LOGNAME=root>
X-Cron-Env: <USER=root>
Date: Sat, 9 Jun 2018 12:26:01 +0800 (CST)
Status: R

/usr/bin:/bin
& 2
Message 2:
From root@localhost.localdomain Sat Jun 9 12:26:01 2018
Return-Path: <root@localhost.localdomain>
X-Original-To: root
Delivered-To: root@localhost.localdomain
From: "(Cron Daemon)" <root@localhost.localdomain>
To: root@localhost.localdomain
Subject: Cron <root@localhost> /bin/bash /root/a.sh
Content-Type: text/plain; charset=UTF-8
Auto-Submitted: auto-generated
Precedence: bulk
X-Cron-Env: <XDG_SESSION_ID=45>
X-Cron-Env: <XDG_RUNTIME_DIR=/run/user/0>
X-Cron-Env: <LANG=en_US.UTF-8>
X-Cron-Env: <SHELL=/bin/sh>
X-Cron-Env: <HOME=/root>
X-Cron-Env: <PATH=/usr/bin:/bin>
X-Cron-Env: <LOGNAME=root>
X-Cron-Env: <USER=root>
Date: Sat, 9 Jun 2018 12:26:01 +0800 (CST)
Status: R

/usr/local/sbin:/usr/sbin:/usr/bin:/bin:/root/bin
& q
Held 2 messages in /var/spool/mail/root
```

