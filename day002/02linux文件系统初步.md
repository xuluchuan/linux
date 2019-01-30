# linux文件系统初步

### 安装后系统要做的操作

#### 1.查看远程连接ssh(secure shell)服务的22端口是否开启(有:22)

```
[root@localhost ~]# ss -tnl
State Recv-Q Send-Q Local Address:Port Peer Address:Port
LISTEN 0 128 :::22 :::*
LISTEN 0 128 *:22 *:*
LISTEN 0 100 ::1:25 :::*
LISTEN 0 100 127.0.0.1:25 *:*
```

#### 2.开启网卡

##### centos6修改ONBOOT=no 改为yes

```
[root@localhost ~]# vi /etc/sysconfig/network-scripts/ifcfg-eth0
ONBOOT=yes
[root@localhost ~]# service network restart
```

##### centos7

```
[root@localhost ~]# vi /etc/sysconfig/network-scripts/ifcfg-enp0s3
ONBOOT=yes
[root@localhost ~]# systemctl restart network.service
```

#### 3.查看ip地址 ifconfig（7 安装 net-tools）或 ip a( ip addr 或 ip addr show 或 ip addr list)

```
[root@localhost ~]# yum -y install net-tools
[root@localhost ~]# ifconfig
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST> mtu 1500
        inet 192.168.1.107 netmask 255.255.255.0 broadcast 192.168.1.255
        inet6 fe80::6937:666e:92c9:c97d prefixlen 64 scopeid 0x20<link>
        ether 08:00:27:52:04:00 txqueuelen 1000 (Ethernet)
        RX packets 342 bytes 36804 (35.9 KiB)
        RX errors 0 dropped 0 overruns 0 frame 0
        TX packets 308 bytes 33472 (32.6 KiB)
        TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0
lo: flags=73<UP,LOOPBACK,RUNNING> mtu 65536
        inet 127.0.0.1 netmask 255.0.0.0
        inet6 ::1 prefixlen 128 scopeid 0x10<host>
        loop txqueuelen 1 (Local Loopback)
        RX packets 22 bytes 2006 (1.9 KiB)
        RX errors 0 dropped 0 overruns 0 frame 0
        TX packets 22 bytes 2006 (1.9 KiB)
        TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0
[root@localhost ~]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:94:b7:d0 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.108/24 brd 192.168.1.255 scope global eth0
    inet6 fe80::a00:27ff:fe94:b7d0/64 scope link
       valid_lft forever preferred_lft forever
```

#### 4.ping主机，查看连通性，ctrl+c断开，有ms则连通

```
[root@localhost ~]# ping 192.168.1.103
PING 192.168.1.103 (192.168.1.103) 56(84) bytes of data.
64 bytes from 192.168.1.103: icmp_seq=1 ttl=64 time=0.383 ms
64 bytes from 192.168.1.103: icmp_seq=2 ttl=64 time=0.233 ms
^C
--- 192.168.1.103 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1054ms
rtt min/avg/max/mdev = 0.233/0.308/0.383/0.075 ms
```

#### 5.清空并关闭防火墙

##### centos7

```
[root@localhost ~]# iptables -L -n （查看防火墙规则）
Chain INPUT (policy ACCEPT)
target prot opt source destination
Chain FORWARD (policy ACCEPT)
target prot opt source destination
Chain OUTPUT (policy ACCEPT)
target prot opt source destination
[root@localhost ~]# iptables -F （清空防火墙规则）
[root@localhost ~]# systemctl disable firewalld.service（禁止开机启动）
[root@localhost ~]# systemctl stop firewalld.service （关闭防火墙）
```

##### centos6

```
[root@localhost ~]# iptables -L -n（查看防火墙规则）
Chain INPUT (policy ACCEPT)
target prot opt source destination
Chain FORWARD (policy ACCEPT)
target prot opt source destination
Chain OUTPUT (policy ACCEPT)
target prot opt source destination
[root@localhost ~]# iptables -F（清空防火墙规则）
[root@localhost ~]# service iptables stop（关闭防火墙）
iptables: Setting chains to policy ACCEPT: filter [ OK ]
iptables: Flushing firewall rules: [ OK ]
iptables: Unloading modules: [ OK ]
[root@localhost ~]# chkconfig iptables off（禁止开机启动）
```

#### 6.putty（ssh客户端）远程连接

#### 7.查看终端所用的shell类型，echo为回显命令

```
[root@localhost ~]# echo $SHELL
/bin/bash
```

#### 8.关闭selinux

- 临时关闭selinux

```
[root@localhost ~]# getenforce
Enforcing
[root@localhost ~]# setenforce 0
[root@localhost ~]# getenforce
Permissive
```

- 永久关闭selinux `[root@localhost ~]# vi /etc/selinux/config`
- 将`SELINUX=enforcing改为SELINUX=disabled` 重启



#### 9.关机命令

##### 重启

```
[root@localhost ~]# reboot(7可以systemctl reboot)
```

##### 关机

```
[root@localhost ~]# poweroff(7可以systemctl poweroff)
```

### 终端设备（terminal）（键盘加显示器）

- 物理终端：控制台 console /dev/console
- 虚拟终端：tty ctrl+alt+F#    /dev/tty#        #为1到6的数字
- 图形终端：tty centos7为进入的虚拟终端，6位/dev/tty7
- 串行终端：ttyS                     /dev/ttyS#    #为数字
- 伪终端：pty                       /dev/pts/#      #为数字

#### tty命令显示终端名称

```
[root@localhost ~]# tty
/dev/pts/0
```

- 每启动一个终端设备，将关联一个用户接口，与用户交互的shell

### 命令提示符

- `[root@localhost ~]# `
- root为当前登录用户名
- localhost为非完整主机名
- ~为用户当前的工作目录 ，~为root的家目录 /root 相对路径
- \#为命令提示符，管理员账户为#，普通用户为$
- 建议使用非管理员账户登录系统，如要管理则临时切换为管理员，操作完即退回

### 自由软件含义

- 自由学习
- 自由修改
- 自由使用
- 自由分发
- 自由创建衍生版
- 以上都是自由的，用开源协议保证

### linux哲学思想

1. 一切皆文件，所有资源包括硬件都抽象为文件
2. 由众多单一功能的程序组成，一个程序只做并做好一件事，组合小程序完成复杂任务
3. 尽量避免与用户交互，易于用编程实现自动化任务
4. 使用文本文件保存配置信息

### 文件是什么？众多文件如何有效组织？

#### 文件

- 文件是按名存取的有边界的数据流

#### 目录

- 目录是路径映射

#### 文件系统

- 文件系统是以目录为索引的层级结构

#### linux文件系统

- 以根/为顶点的倒置树状结构
- /dev/pts/0的第一个/为根目录，后面的/为路径分隔符，windows为\

#### 路径表示

##### 绝对路径

- 从根开始表示路径

##### 相对路径

- 从当前位置开始表示路径

#### 文件名法则

1. 严格区分大小写，windows不区分
2. 目录也是文件，在同一路径下不能重名
3. 文件名使用除了/之外的所有字符，255最大长度

#### 其他

- 用户登录后默认在家目录，普通用户在/home/USERNAME，管理员在/root `cd ~` 进入家目录
- 家目录：用户创建文件和管理文件的位置
- 工作目录：当前目录（working directory）

##### 查看当前目录

```
[root@localhost ~]# pwd
/root
```

##### 查看基名

- 基名 basename：最右侧的文件或目录名

```
[root@localhost ~]# basename /dev/pts/0
0
```

##### 查看目录名

- 目录名 dirname：左侧的路径

```
[root@localhost ~]# dirname /dev/pts/0
/dev/pts
```
