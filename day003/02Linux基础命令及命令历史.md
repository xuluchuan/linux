# Linux基础命令及命令历史

### alias

#### 查看命令别名

##### 6

```
[root@localhost ~]# alias
alias cp='cp -i'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
```

##### 7

```
[root@localhost ~]# alias
alias cp='cp -i'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias l.='ls -d .* --color=auto'
alias ll='ls -l --color=auto'
alias ls='ls --color=auto'
alias mv='mv -i'
alias rm='rm -i'
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
```

#### 设置别名

```
[root@localhost ~]# alias grep='grep --color=auto'
```

#### 撤销别名

```
[root@localhost ~]# unalias grep
```

#### 将alias设置在~/.bashrc里，此用户可以永久生效

##### 6

```
[root@localhost ~]# vi .bashrc
加入如下内容
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
[root@localhost ~]# . .bashrc
```

### which

- 查看外部命令的二进制文件路径

```
[root@localhost ~]# which which
alias which='alias | /usr/bin/which --tty-only --read-alias --show-dot --show-tilde'
        /usr/bin/which
[root@localhost ~]# which ls
alias ls='ls --color=auto'
        /bin/ls
```

- --skip-alias 或 \which可以跳过别名

```
[root@localhost ~]# \which ls
/bin/ls
[root@localhost ~]# which --skip-alias ls
/bin/ls
```

### whereis

- 查看命令的二进制路径，源码路径，手册路径
- whereis -b只显示二进制
- whereis -m只显示手册
- whereis -s 只显示源码

```
[root@localhost ~]# whereis ls
ls: /bin/ls /usr/share/man/man1/ls.1.gz
[root@localhost ~]# whereis -b ls
ls: /bin/ls
[root@localhost ~]# whereis -m ls
ls: /usr/share/man/man1/ls.1.gz
[root@localhost ~]# whereis -s ls
ls:
```

### who

- 查看登录系统的不同用户
- 用户名
- 终端
- 登录时间
- 远程主机ip

```
[root@localhost ~]# who
root pts/0 2018-05-17 03:33 (192.168.1.103)
```

- who -b 系统此次启动时间

```
[root@localhost ~]# who -b
         system boot 2018-05-17 03:32
```

- who -r 查看运行级别

```
[root@localhost ~]# who -r
         run-level 3 2018-05-17 03:32
```

### w

- 增强版who，还可查看资源占用和运行什么命令

```
[root@localhost ~]# w
 03:52:54 up 20 min, 1 user, load average: 0.00, 0.00, 0.00
USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
root pts/0 192.168.1.103 03:33 0.00s 0.08s 0.00s w
```

### bash shell基础特性之一命令历史

1. 命令历史可以使用上下箭头翻出
2. shell进程会在会话中保存此前用户执行的命令到内存中
3. 当会话正常退出时，命令历史将保存到文件中
4. HISTSIZE 命令历史条数

```
[root@localhost ~]# echo $HISTSIZE
1000
```

5.HISTFILE 命令历史保存文件

```
[root@localhost ~]# echo $HISTFILE
/root/.bash_history
```

6.HISTFILESIZE 命令历史文件条数

```
[root@localhost ~]# echo $HISTFILESIZE
1000
```

7.history的选项

  + history -c 清空命令历史
  + history -d 676 5 删除第676条命令历史之后的5条
  + history -w 将当前命令历史写入到文件中
  + history -r 读出文件中的命令历史到当前命令历史中
  + history 10 只显示最近10条命令历史

```
[root@localhost ~]# history 10
  387 man who
  388 hisotyr
  389 history
  390 ls
  391 cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
  392 ls /etc/sysconfig/network-scripts/ifcfg-enp0s3
  393 echo $HISTSIZE
  394 history -d 222 5
  395 history
  396 history 10
[root@localhost ~]# history -d 394 3
[root@localhost ~]# history 10
  388 hisotyr
  389 history
  390 ls
  391 cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
  392 ls /etc/sysconfig/network-scripts/ifcfg-enp0s3
  393 echo $HISTSIZE
  394 history
  395 history 10
  396 history -d 394 3
  397 history 10
```

8.调用命令历史列表
    + !# 再次执行命令历史列表中的第#条命令
    + !! 或 向上箭头 再次执行上一条命令
    + !STRING 再次执行命令历史列表中追溯最近一个以STRING开头的命令
    + !$ 或 Esc,. 调用上一条命令的最后一条参数

```
[root@localhost ~]# !393
echo $HISTSIZE
1000
[root@localhost ~]# !!
echo $HISTSIZE
1000
[root@localhost ~]# !h
history 10
  390 ls
  391 cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
  392 ls /etc/sysconfig/network-scripts/ifcfg-enp0s3
  393 echo $HISTSIZE
  394 history
  395 history 10
  396 history -d 394 3
  397 history 10
  398 echo $HISTSIZE
  399 history 10
[root@localhost ~]# ls /etc/sysconfig/network-scripts/ifcfg-enp0s3 
/etc/sysconfig/network-scripts/ifcfg-enp0s3
[root@localhost ~]# cat !$
cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp0s3
UUID=2c1bcf72-a18c-4a21-a3cc-40061ef68610
DEVICE=enp0s3
ONBOOT=yes
```

9.控制命令历史特性 环境变量 HISTCONTROL
    + 默认是ignoredups忽略重复命令
    + ignorespace忽略以空白开头的命令
    + ignoreboth以上两者同时生效

```
[root@localhost ~]# echo $HISTCONTROL
ignoredups
[root@localhost ~]# HISTCONTROL=ignorespace
[root@localhost ~]# history 10
  396 history -d 394 3
  397 history 10
  398 echo $HISTSIZE
  399 history 10
  400 ls /etc/sysconfig/network-scripts/ifcfg-enp0s3
  401 cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
  402 echo $HISCONTROL
  403 echo $HISTCONTROL
  404 HISTCONTROL=ignorespace
  405 history 10
[root@localhost ~]# mysql -uroot -p123456
-bash: mysql: command not found
[root@localhost ~]# history 10
  397 history 10
  398 echo $HISTSIZE
  399 history 10
  400 ls /etc/sysconfig/network-scripts/ifcfg-enp0s3
  401 cat /etc/sysconfig/network-scripts/ifcfg-enp0s3
  402 echo $HISCONTROL
  403 echo $HISTCONTROL
  404 HISTCONTROL=ignorespace
  405 history 10
  406 history 10
[root@localhost ~]# !403
echo $HISTCONTROL
ignorespace
```
