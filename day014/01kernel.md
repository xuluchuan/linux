# 内核

### 内核组成

- 1.kernel ：/boot/vmlinuz-VERSION-RELEASE
- 2.kernel object 内核模块： /lib/modules/VERSION-RELEASE
    + 内核和内核模块，版本要匹配
    + []:不编译，[M]编译为内核模块，[*] 编译为内核核心
- 3.ramdisk /boot/initramfs--VERSION-RELEASE.img辅助性文件，提供目标设备驱动，逻辑设备驱动，文件系统，是简装版的rootfs

```
[root@centos7-mould ~]# ll -h /boot/vmlinuz-3.10.0-862.3.2.el7.x86_64
-rwxr-xr-x 1 root root 6.0M May 22 07:50 /boot/vmlinuz-3.10.0-862.3.2.el7.x86_64
[root@centos7-mould ~]# ll -h /boot/initramfs-3.10.0-862.3.2.el7.x86_64.img
-rw------- 1 root root 18M Jun 12 11:54 /boot/initramfs-3.10.0-862.3.2.el7.x86_64.img
[root@centos7-mould ~]# ll -h /lib/modules/3.10.0-862.3.2.el7.x86_64/
total 3.2M
lrwxrwxrwx 1 root root 42 Jun 12 11:48 build -> /usr/src/kernels/3.10.0-862.3.2.el7.x86_64
drwxr-xr-x 2 root root 6 May 22 07:52 extra
drwxr-xr-x 12 root root 128 Jun 12 11:48 kernel
-rw-r--r-- 1 root root 801K Jun 12 11:53 modules.alias
-rw-r--r-- 1 root root 767K Jun 12 11:53 modules.alias.bin
-rw-r--r-- 1 root root 1.4K May 22 07:52 modules.block
-rw-r--r-- 1 root root 7.0K May 22 07:50 modules.builtin
-rw-r--r-- 1 root root 8.8K Jun 12 11:53 modules.builtin.bin
-rw-r--r-- 1 root root 274K Jun 12 11:53 modules.dep
-rw-r--r-- 1 root root 379K Jun 12 11:53 modules.dep.bin
-rw-r--r-- 1 root root 361 Jun 12 11:53 modules.devname
-rw-r--r-- 1 root root 132 May 22 07:52 modules.drm
-rw-r--r-- 1 root root 82 May 22 07:52 modules.modesetting
-rw-r--r-- 1 root root 1.8K May 22 07:52 modules.networking
-rw-r--r-- 1 root root 94K May 22 07:50 modules.order
-rw-r--r-- 1 root root 490 Jun 12 11:53 modules.softdep
-rw-r--r-- 1 root root 374K Jun 12 11:53 modules.symbols
-rw-r--r-- 1 root root 459K Jun 12 11:53 modules.symbols.bin
lrwxrwxrwx 1 root root 5 Jun 12 11:48 source -> build
drwxr-xr-x 2 root root 6 May 22 07:52 updates
drwxr-xr-x 2 root root 95 Jun 12 11:48 vdso
drwxr-xr-x 2 root root 6 May 22 07:52 weak-updates
```

### 内核信息查看

- uname -r kernel发行号
- uname -n 主机名
- uname -a 所有内核信息

```
[root@centos7-mould ~]# uname -r
3.10.0-862.3.2.el7.x86_64
[root@centos7-mould ~]# uname -n
centos7-mould
[root@centos7-mould ~]# uname -a
Linux centos7-mould 3.10.0-862.3.2.el7.x86_64 #1 SMP Mon May 21 23:36:36 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```

### 模块信息查看，装载，卸载

- lsmod 查看已经装载的内核

```
[root@centos7-mould ~]# lsmod
Module Size Used by
ppdev 17671 0
sg 40721 0
pcspkr 12718 0
i2c_piix4 22401 0
parport_pc 28205 0
parport 46395 2 ppdev,parport_pc
video 24538 0
i2c_core 63151 1 i2c_piix4
ip_tables 27126 0
xfs 1003971 2
libcrc32c 12644 1 xfs
sr_mod 22416 0
sd_mod 46322 4
cdrom 42556 1 sr_mod
crc_t10dif 12912 1 sd_mod
crct10dif_generic 12647 1
crct10dif_common 12595 2 crct10dif_generic,crc_t10dif
ata_generic 12923 0
pata_acpi 13053 0
ahci 34056 3
libahci 31992 1 ahci
ata_piix 35052 0
libata 242992 5 ahci,pata_acpi,libahci,ata_generic,ata_piix
e1000 137574 0
crc32c_intel 22094 1
serio_raw 13434 0
```

### modinfo

- modinfo MODNAME 查看具体内核的信息
    + -n：查看内核文件路径
    + -F：指定字段信息

```
[root@centos7-mould ~]# modinfo btrfs
filename: /lib/modules/3.10.0-862.3.2.el7.x86_64/kernel/fs/btrfs/btrfs.ko.xz
license: GPL
alias: devname:btrfs-control
alias: char-major-10-234
alias: fs-btrfs
retpoline: Y
rhelversion: 7.5
srcversion: 6DD3FEDCB50AFCFF96FED7D
depends: raid6_pq,xor
intree: Y
vermagic: 3.10.0-862.3.2.el7.x86_64 SMP mod_unload modversions
signer: CentOS Linux kernel signing key
sig_key: D8:74:54:18:48:B9:21:C5:E0:40:01:F8:06:AC:D0:6C:EB:48:1C:7C
sig_hashalgo: sha256
[root@centos7-mould ~]# modinfo -n btrfs
/lib/modules/3.10.0-862.3.2.el7.x86_64/kernel/fs/btrfs/btrfs.ko.xz
```

### modprobe

- modprobe  
    + MODULENAME 装载内核模块
    + -r MODULENAME 卸载内核模块

```
[root@centos7-mould ~]# lsmod|grep btrfs
[root@centos7-mould ~]# modprobe btrfs
[root@centos7-mould ~]# lsmod|grep btrfs
btrfs 1073861 0
raid6_pq 102527 1 btrfs
xor 21411 1 btrfs
[root@centos7-mould ~]# modprobe -r btrfs
[root@centos7-mould ~]# lsmod|grep btrfs
```

- depmod：模块依赖生成工具
- insmod FILENAME：装载
- rmmod MODNAME：卸载

### 重新制作ramdisk文件

- mkinitrd/dracut /boot/initramfs-\$(uname -r).img $(uname -r)
- --with=MODULE:加载除默认模块之外的模块

### /proc

- 内核信息输出伪文件系统
- 是内核状态和统计信息的输出接口，其中/proc/sys是可写的配置接口
- 分为只读和可写

### 修改内核参数

- 1.sysctl（临时生效）
    + sysctl -a：查看所有已经配置的内核参数
    + sysctl VARIABLE：查看指定内核参数
    + sysctl -w VARIABLE=VALUE：临时设置内核参数
- 2.文件重定向（临时生效）
    + cat 查看 （net.ipv4.ip_forwaod参数对应文件/proc/sys/net/ipv4/ip_forword）
    + echo 设置

```
[root@centos7-mould ~]# cat /proc/sys/net/ipv4/ip_forward
0
[root@centos7-mould ~]# echo "1" > /proc/sys/net/ipv4/ip_forward
[root@centos7-mould ~]# cat /proc/sys/net/ipv4/ip_forward
1
[root@centos7-mould ~]# echo "0" > /proc/sys/net/ipv4/ip_forward
[root@centos7-mould ~]# cat /proc/sys/net/ipv4/ip_forward
0
```

- 3.配置文件/etc/sysct..conf修改
    + VARIABLE=VALUE
    + sysctl -p：重读配置文件

```
[root@centos7-mould ~]# echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf
[root@centos7-mould ~]# vim /etc/sysctl.conf
[root@centos7-mould ~]# sysctl -p
net.ipv4.ip_forward = 1
[root@centos7-mould ~]# cat /proc/sys/net/ipv4/ip_forward
1
[root@centos7-mould ~]# vim /etc/sysctl.conf
[root@centos7-mould ~]# sysctl -p
[root@centos7-mould ~]# cat /proc/sys/net/ipv4/ip_forward
1
[root@centos7-mould ~]# echo "0" > /proc/sys/net/ipv4/ip_forward
[root@centos7-mould ~]# cat /proc/sys/net/ipv4/ip_forward
0
```

### 内核参数

- net.ipv4.ip_forward：0，关闭 1，开启 路由转发功能（主机做路由器）
- vm.drop_caches：0默认，1清除cache，2清除cache和buffer
- kernel.hostname ：主机名
- net.ipv4.icmp_echo_ignore_all 0：可被ping 1：禁被ping

```
[root@centos7-mould ~]# cat /proc/sys/net/ipv4/ip_forward
0
[root@centos7-mould ~]# cat /proc/sys/vm/drop_caches
0
[root@centos7-mould ~]# cat /proc/sys/net/ipv4/icmp_echo_ignore_all
0
[root@centos7-mould ~]# cat /proc/sys/kernel/hostname
centos7-mould
```

### /sys

- 使用udev根据在/etc/udev/rules.d/*的配置文件读取/sys目录下内核识别出的硬件设备的信息，并创建设备文件
```
[root@centos6-mould ~]# grep -Ev "^$|^#" /etc/udev/rules.d/70-persistent-net.rules
SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", ATTR{address}=="08:00:27:94:b7:d0", ATTR{type}=="1", KERNEL=="eth*", NAME="eth0"
```

### 内核编译

#### 准备

##### 开发环境

- Development Tools
- Server Platform Development
- ncurses-devel

```
[root@centos7-mould ~]# yum -y install ncurses-devel
```

##### 硬件设备信息

- cpu：cat /proc/cpuinfo
    + lscpu
    + x86info -a

```
[root@centos7-mould ~]# lscpu
Architecture: x86_64
CPU op-mode(s): 32-bit, 64-bit
Byte Order: Little Endian
CPU(s): 2
On-line CPU(s) list: 0,1
Thread(s) per core: 1
Core(s) per socket: 2
Socket(s): 1
NUMA node(s): 1
Vendor ID: GenuineIntel
CPU family: 6
Model: 37
Model name: Intel(R) Core(TM) i3 CPU M 330 @ 2.13GHz
Stepping: 2
CPU MHz: 2128.022
BogoMIPS: 4256.04
Hypervisor vendor: KVM
Virtualization type: full
L1d cache: 32K
L1i cache: 32K
L2 cache: 256K
L3 cache: 3072K
NUMA node0 CPU(s): 0,1
Flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall rdtscp lm constant_tsc rep_g ood nopl xtopology nonstop_tsc pni ssse3 cx16 sse4_1 sse4_2 x2apic popcnt hyperv isor lahf_lm
[root@centos7-mould ~]# lscpu
Architecture: x86_64
CPU op-mode(s): 32-bit, 64-bit
Byte Order: Little Endian
CPU(s): 2
On-line CPU(s) list: 0,1
Thread(s) per core: 1
Core(s) per socket: 2
Socket(s): 1
NUMA node(s): 1
Vendor ID: GenuineIntel
CPU family: 6
Model: 37
Model name: Intel(R) Core(TM) i3 CPU M 330 @ 2.13GHz
Stepping: 2
CPU MHz: 2128.022
BogoMIPS: 4256.04
Hypervisor vendor: KVM
Virtualization type: full
L1d cache: 32K
L1i cache: 32K
L2 cache: 256K
L3 cache: 3072K
NUMA node0 CPU(s): 0,1
Flags: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc pni ssse3 cx16 sse4_1 sse4_2 x2apic popcnt hypervisor lahf_lm
```

- PCI: lspci -v 或 -vv

```
[root@centos7-mould ~]# yum -y install pciutils
[root@centos7-mould ~]# lspci
00:00.0 Host bridge: Intel Corporation 440FX - 82441FX PMC [Natoma] (rev 02)
00:01.0 ISA bridge: Intel Corporation 82371SB PIIX3 ISA [Natoma/Triton II]
00:01.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
00:02.0 VGA compatible controller: InnoTek Systemberatung GmbH VirtualBox Graphics Adapter
00:03.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet Controller (rev 02)
00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox Guest Service
00:06.0 USB controller: Apple Inc. KeyLargo/Intrepid USB
00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 08)
00:0b.0 USB controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) USB2 EHCI Controller
00:0d.0 SATA controller: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) SATA Controller [AHCI mode] (rev 02)
```
- USB:lsusb
- 硬盘：lsblk
- 全部硬件信息：centos6 hal-device

##### 系统功能

- uname -r 查看内核版本

```
[root@centos7-mould ~]# uname -r
3.10.0-862.3.2.el7.x86_64
```

### 内核编译过程

#### 获取源码

- 去www.kernel.org 下载最新源码
- 解压文件到/usr/src目录
- 软链接 到 linux 目录

```
[root@centos7-mould src]# tar xf linux-4.17.3.tar.xz
[root@centos7-mould src]# ln -s linux-4.17.3 linux
[root@centos7-mould src]# cd linux
```

#### 配置内核选项

- 更新模式，在.config文件基础上修改
    + 1.make config：遍历
    + 2.make menuconfig：文本
    + 3.make gconfig：gtk
    + 4.make xconfig：qt
- 支持全新配置
    + 1.make defconfig：默认
    + 2.make allnoconfig 所有no
- 将之前内核的模板拷贝，cp /boot/config* .config
- 建议使用make menuconfig
- 可以设置process family，打开ReiserFS NTFS支持

```
[root@centos7-mould linux]# cp /boot/config-3.10.0-862.3.2.el7.x86_64 .config
[root@centos7-mould linux]# make menuconfig
```

#### 编译内核

- 建议使用screen命令安装（打开虚拟终端，不依赖ssh终端，断开后程序仍可运行）
    + 1.打开screen screen
    + 2.拆除screen ctrl+a d
    + 3.列出screen screen -ls
    + 4.连接复用screen screen -r ID
    + 5.关闭screen exit
- make -j # 选择多线程编译
- 还可以编译内核的一部分代码或只编译一个模块
- 使用make ARCH=arch_name 交叉编译
- 重新编译
    + 1.make clean 清除绝大多数
    + 2.make mrproper：make clean 和 config
    + 3.make distclean：make mrproper和patches
```
[root@centos7-mould linux]# yum -y install elfutils-libelf-devel openssl-devel bc
[root@centos7-mould linux]# make -j 2
```

#### 安装内核模块

- make modules_install

```
[root@centos7-mould linux]# make modules_install
```

#### 安装内核

+ make install
```
[root@centos7-mould linux]# make install
```

### grub菜单默认内核

+ 修改/boot/grub2/grub.cfg

