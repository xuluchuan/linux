# centos6模板机

## 1. ifup 

``` shell
ifup eth0
ip a 

```

- ip a找到ip后，通过xshell连接ssh

## 2. 安装软件wget和vim

``` shell
yum -y install wget vim

```

## 3. 安装阿里云的yum源

``` shell
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
yum clean all
yum makecache
yum -y install lftp nc telnet tree ntpdate

```

## 4. 增大文件打开限制 和进程限制

``` shell
echo "
* - nofile 65535
* - memlock unlimited
" >> /etc/security/limits.conf

echo "
* - nproc 65535
" >> /etc/security/limits.d/90-nproc.conf

```

## 5. 关闭iptables

``` shell
iptables -F
service iptables stop
chkconfig iptables off

```

## 6. 关闭selinux

``` shell
setenforce 0
sed -i -r 's#^SELINUX=(.*)#SELINUX=disabled#g' /etc/selinux/config

```

## 7. 修改fstab mount挂载参数

``` shell
sed -i -r 's#(.*) / (.*)defaults(.*)#\1 / \2defaults,barrier=0,noatime\3#g' /etc/fstab
```

## 8. 修改内核

``` shell
cat > /etc/sysctl.conf << EOF
# Kernel sysctl configuration file for Red Hat Linux
#
# For binary values, 0 is disabled, 1 is enabled.  See sysctl(8) and
# sysctl.conf(5) for more details.
#
# Use '/sbin/sysctl -a' to list all possible parameters.

#最大限度使用物理内存
vm.swappiness = 0
#内核立即分配物理内存
vm.overcommit_memory = 1
#关闭numa
vm.zone_reclaim_mode = 0
#决定检查一次相邻层记录的有效性的周期
net.ipv4.neigh.default.gc_stale_time=120
#负载均衡配置
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce=2
net.ipv4.conf.all.arp_announce=2
net.ipv6.conf.all.disable_ipv6 = 0
net.ipv6.conf.default.disable_ipv6 = 0
net.ipv6.conf.lo.disable_ipv6 = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296


# PS：所有的TCP/IP参数都位于/proc/sys/net目录下，
# 例如参数net.core.rmem_default，则在/proc/sys/net/core/rmem_default


net.ipv4.ip_forward = 0
#0表示禁用 IPv4 包转送


net.ipv4.tcp_retries2 = 5
#控制内核向已经建立连接的远程主机重新发送数据的次数，低值可以更早的检测到与远程主机失效的连接，因此服务器可以更快的释放该连接，可以修改为5


net.ipv4.tcp_syncookies = 1
#表示开启SYN Cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；


net.ipv4.tcp_max_tw_buckets = 6000
#表示系统同时保持TIME_WAIT套接字的最大数量


net.ipv4.tcp_sack = 1
#关闭tcp_sack
#启用有选择的应答（Selective Acknowledgment），
#这可以通过有选择地应答乱序接收到的报文来提高性能（这样可以让发送者只发送丢失的报文段）；
#（对于广域网通信来说）这个选项应该启用，但是这会增加对 CPU 的占用


net.ipv4.tcp_window_scaling = 1
#设置tcp/ip会话的滑动窗口大小是否可变。参数值为布尔值，为1时表示可变，为0时表示不可变。tcp/ip通常使用的窗口最大可达到 65535 字节，对于高速网络，该值可能太小，这时候如果启用了该功能，可以使tcp/ip滑动窗口大小增大数个数量级，从而提高数据传输的能力


net.ipv4.tcp_rmem = 4096 87380 4194304
#TCP接收读缓冲区，3个字段分别是min，default，max。
#Min：为TCP socket预留用于接收缓冲的内存数量，即使在内存出现紧张情况下TCP socket都至少会有这么多数量的内存用于接收缓冲。


net.ipv4.tcp_wmem = 4096 16384 4194304
#TCP接收写缓冲区，3个字段分别是min，default，max。
#Min：为TCP socket预留用于接收缓冲的内存数量，即使在内存出现紧张情况下TCP socket都至少会有这么多数量的内存用于接收缓冲。


net.core.wmem_default = 8388608
#默认的TCP发送缓冲区大小(以字节为单位)


net.core.rmem_default = 8388608
#默认的TCP接收缓冲区大小(以字节为单位)


net.core.rmem_max = 16777216
#最大的TCP接收缓冲区大小(以字节为单位)


net.core.wmem_max = 16777216
#最大的TCP发送缓冲区大小(以字节为单位)


net.core.netdev_max_backlog = 262144
#在每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目。


net.core.somaxconn = 262144
#用来限制监听(LISTEN)队列最大数据包的数量，超过这个数量就会导致链接超时或者触发重传机制


net.ipv4.tcp_max_orphans = 3276800
#系统所能处理不属于任何进程的TCP sockets最大数量。假如超过这个数量，那么不属于任何进程的连接会被立即reset，并同时显示警告信息。之所以要设定这个限制﹐纯粹为了抵御那些简单的 DoS 攻击﹐千万不要依赖这个或是人为的降低这个限制，更应该增加这个值(如果增加了内存之后)。每个孤儿套接字最多能够吃掉你64K不可交换的内存。


net.ipv4.tcp_max_syn_backlog = 262144
#表示SYN队列的长度，默认为1024，加大队列长度为8192，可以容纳更多等待连接的网络连接数。


net.ipv4.tcp_timestamps = 1
#TCP时间戳（会在TCP包头增加12个字节），以一种比重发超时更精确的方法（参考RFC 1323）来启用对RTT 的计算，为实现更好的性能应该启用这个选项。


net.ipv4.tcp_synack_retries = 1
#tcp_synack_retries 显示或设定 Linux 核心在回应 SYN 要求时会尝试多少次重新发送初始 SYN,ACK 封包后才决定放弃。这是所谓的三段交握 (threeway handshake) 的第二个步骤。即是说系统会尝试多少次去建立由远端启始的 TCP 连线。tcp_synack_retries 的值必须为正整数，并不能超过 255。因为每一次重新发送封包都会耗费约 30 至 40 秒去等待才决定尝试下一次重新发送或决定放弃。tcp_synack_retries 的缺省值为 5，即每一个连线要在约 180 秒 (3 分钟) 后才确定逾时.


net.ipv4.tcp_syn_retries = 1
#对于一个新建连接，内核要发送多少个 SYN 连接请求才决定放弃。不应该大于255，默认值是5，对应于180秒左右时间。(对于大负载而物理通信良好的网络而言,这个值偏高,可修改为2.这个值仅仅是针对对外的连接,对进来的连接,是由tcp_retries1 决定的)


net.ipv4.tcp_tw_recycle = 0
#表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。慎重开启，因为网上说很多开启了此参数会导致很多连接失败


net.ipv4.tcp_tw_reuse = 1
#表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；


net.ipv4.tcp_mem = 94500000 915000000 927000000
#确定TCP栈应该如何反映内存使用，每个值的单位都是内存页（通常是4KB）。第一个值是内存使用的下限；第二个值是内存压力模式开始对缓冲区使用应用压力的上限；第三个值是内存使用的上限。在这个层次上可以将报文丢弃，从而减少对内存的使用。对于较大的BDP可以增大这些值（注意，其单位是内存页而不是字节）。


net.ipv4.tcp_fin_timeout = 15
#对于本端断开的socket连接，TCP保持在FIN-WAIT-2状态的时间（秒）。对方可能会断开连接或一直不结束连接或不可预料的进程死亡。


net.ipv4.tcp_keepalive_time = 30
#TCP发送keepalive探测消息的间隔时间（秒），用于确认TCP连接是否有效。默认值7200秒，即两个小时


net.ipv4.tcp_keepalive_intvl = 30
#探测消息未获得响应时，重发该消息的间隔时间（秒）。默认值75秒


net.ipv4.tcp_keepalive_probes = 3
#在认定TCP连接失效之前，最多发送多少个keepalive探测消息。默认值为9次


net.ipv4.ip_local_port_range = 1024 65000
#表示TCP/UDP协议允许使用的本地端口号


net.netfilter.nf_conntrack_max = 6553500
#链接跟踪表最大数目
EOF

cat > /etc/rc.local << EOF
#!/bin/sh
#
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.

touch /var/lock/subsys/local
echo "never" > /sys/kernel/mm/transparent_hugepage/enabled
echo "never" > /sys/kernel/mm/transparent_hugepage/defrag
echo "deadline" > /sys/block/sda/queue/scheduler
EOF

sysctl -p

sed -i -r '/vmlinuz-2.6.32/s#(.*)#\1 numa=off#g' /boot/grub/grub.conf

```

## 9.修改主机名和ip

``` shell

cat > /etc/sysconfig/network-scripts/ifcfg-eth0 << EOF
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=192.168.135.3
NETMASK=255.255.255.0
GATEWAY=192.168.135.2
DNS1=192.168.135.2
DNS2=114.114.114.114
EOF

cat > /root/hostip.sh << EOF
read -p "username:" HOST
read -p "ip last segment:" IP
hostname \${HOST} 
sed -i -r "s#HOSTNAME=(.*)#HOSTNAME=\${HOST}#g" /etc/sysconfig/network
sed -i -r "1s#(.*) (.*)#\1 \${HOST}#g" /etc/hosts
sed -i -r "s#IPADDR=192\.168\.135\.(.*)#IPADDR=192.168.135.\${IP}#g" /etc/sysconfig/network-scripts/ifcfg-eth0
/etc/init.d/network restart
skill -9 -t tty1
EOF

```

## 10. 终端执行

```
sh /root/hostip.sh

```

## 11. 重启

```
rm -f /etc/udev/rules.d/70-persistent-net.rules
history -c
:>.bash_history
reboot 

```