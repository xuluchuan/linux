# Linux磁盘及文件系统管理进阶

### 查看系统信息

```
[root@localhost ~]# cat /etc/issue
CentOS release 6.9 (Final)
Kernel \r on an \m
[root@localhost ~]# cat /etc/issue
\S
Kernel \r on an \m
[root@localhost ~]# cat /etc/redhat-release
CentOS release 6.9 (Final)
[root@localhost ~]# cat /etc/redhat-release
CentOS Linux release 7.4.1708 (Core)
```

### 查看内核信息

```
[root@localhost ~]# uname -r
2.6.32-696.el6.x86_64
[root@localhost ~]# uname -r
3.10.0-693.el7.x86_64
```

### 内核级文件系统

- 内核级文件系统的组成部分：由内核提供文件系统驱动
- centos6默认是ext4

```
[root@localhost ~]# lsmod|grep ext4
ext4 381065 2
jbd2 93284 1 ext4
mbcache 8193 1 ext4
```

- centos7默认是xfs

```
[root@localhost ~]# lsmod|grep xfs
xfs 978100 2
libcrc32c 12644 1 xfs

```

### 管理工具：用户空间的应用程序

#### 创建文件系统工具

- mkfs -t ext2/3/4 xfs
- mkfs.ext2/3/4 DEVICE ext系列专用 
- mkfs.xfs xfs专用
- centos6安装xfs，yum -y install xfsprogs

```
[root@localhost ~]# mkfs.ext3 /dev/sdb1 
[root@localhost ~]# mkfs.xfs -f /dev/sdb1
[root@localhost ~]# mkfs.ext4 /dev/sdb1
```

#### ext系列专用工具

- mke2fs 
    - -t {ext2|ext3|ext4} 指明类型，默认ext2
    - -b {1024|2048|4096} :默认4096，指明文件系统块大小
    - -L LABEL 指明卷标
    - -j 启动日志，ext3
    - -i # ： 指明多少字节一个inode，inode/block比
    - -N：指明inode数
    - -O：指明文件系统特性，如has_journal ^取消特性
    - -m # :指定预留空间百分比 默认5%
- e2label 卷标管理
    - e2label DEVICE LABEL 不加LABEL是查看，加上是设置
- tune2fs 查看和调整ext系列某些属性
    - -l查看超级块信息 FileSystem state：clean 或dirty
    - -j 开启日志，ext2升级为ext3
    - -L 设定卷标
    - -m # ：指定预留空间百分比 
    - -O：调整文件系统特性
    - -o：调整默认挂载属性 tune2fs -o acl
- dumpe2fs 显示ext系列文件系统属性信息
    - -h：仅显示超级块信息
- e2fsck：文件系统检测与修复
    - -y：所有问题回答yes
    - -f：clean状态也修复

#### xfs_admin基本用法：

```
1
xfs_admin -l /dev/sda3   #查看xfs格式文件系统的卷标
2
xfs_admin -L linux /dev/sda3  #设置xfs格式文件系统的卷标为linux
3
xfs_admin -l /dev/sda3  #再次查看xfs格式文件系统的卷标
```

```
[root@localhost ~]# blkid /dev/sdb1
/dev/sdb1: UUID="2b860243-f205-428e-8cb8-454c93411b06" TYPE="ext4"
[root@localhost ~]# e2label /dev/sdb1 MYDATA
[root@localhost ~]# blkid /dev/sdb1
/dev/sdb1: LABEL="MYDATA" UUID="2b860243-f205-428e-8cb8-454c93411b06" TYPE="ext4"
[root@localhost ~]# tune2fs -l /dev/sdb1
tune2fs 1.42.9 (28-Dec-2013)
Filesystem volume name: MYDATA
Last mounted on: <not available>
Filesystem UUID: 2b860243-f205-428e-8cb8-454c93411b06
Filesystem magic number: 0xEF53
Filesystem revision #: 1 (dynamic)
Filesystem features: has_journal ext_attr resize_inode dir_index filetype extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags: signed_directory_hash
Default mount options: user_xattr acl
Filesystem state: clean
Errors behavior: Continue
Filesystem OS type: Linux
Inode count: 131072
Block count: 524288
Reserved block count: 26214
Free blocks: 498132
Free inodes: 131061
First block: 0
Block size: 4096
Fragment size: 4096
Group descriptor size: 64
Reserved GDT blocks: 255
Blocks per group: 32768
Fragments per group: 32768
Inodes per group: 8192
Inode blocks per group: 512
Flex block group size: 16
Filesystem created: Fri Jun 1 11:49:17 2018
Last mount time: n/a
Last write time: Fri Jun 1 12:37:35 2018
Mount count: 0
Maximum mount count: -1
Last checked: Fri Jun 1 11:49:17 2018
Check interval: 0 (<none>)
Lifetime writes: 65 MB
Reserved blocks uid: 0 (user root)
Reserved blocks gid: 0 (group root)
First inode: 11
Inode size: 256
Required extra isize: 28
Desired extra isize: 28
Journal inode: 8
Default directory hash: half_md4
Directory Hash Seed: d080298d-e97d-4ae7-b63c-b07ece2382d3
Journal backup: inode blocks
```

### 文件系统检测修复工具

- fsck，当进程意外中止或系统崩溃，导致写入操作非正常终止，文件可能损坏，此时应该离线检测文件系统
    - -t FSTYPE 或fsck.FSTYPE
    - -a 自动修复所有错误
    - -r 交互式修复

### blkid命令

- blkid DEVICE 查找属性
- -L 卷标 查找卷标对应的设备
- -U UUID 查找UUID对应的设备

```
[root@localhost ~]# blkid /dev/sdb2
/dev/sdb2: UUID="3ea8533f-f7b9-4552-87b1-ae3591c37200" TYPE="swap"
```

### swap文件系统

- 必须使用独立的文件系统
- 创建swap需要修改id为82
- 使用mkswap DEVICE     
- 用mkswap -L 命令可以给一个swap设卷标。

```
[root@localhost ~]# fdisk -l /dev/sdb
Disk /dev/sdb: 8589 MB, 8589934592 bytes, 16777216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x519a8c05
   Device Boot Start End Blocks Id System
/dev/sdb1 2048 4196351 2097152 83 Linux
/dev/sdb2 4196352 8390655 2097152 82 Linux swap / Solaris
[root@localhost ~]# mkswap -L MYSWAP /dev/sdb2
mkswap: /dev/sdb2: warning: wiping old swap signature.
Setting up swapspace version 1, size = 2097148 KiB
LABEL=MYSWAP, UUID=7559abfb-138f-44d7-9497-e28f42ac70b4
```


### U盘

- 只有vfat（fat32）格式才能在windows和linux上交叉使用
- 使用mkfs.vfat创建u盘文件系统

### 挂载点（mount point）

- 挂载点是其他文件系统的访问入口，若其他文件系统要能访问，需要关联到根文件系统中的某个目录中，此关联为挂载，此目录为挂载点，挂载点是实现存在的目录，挂载后挂载点原有的文件会隐藏
- 挂载：mount OPTIONS -t FSTYPE -o OPTIONS DEVICE DIR
- 查看已挂载文件系统：cat /etc/mtab 或 mount 
- 卸载：umount DEVICE 或 MOUNT POINT
- 挂载完后正在被进程访问到的挂载点无法被卸载

```
[root@localhost ~]# mount /dev/sdb1 /mnt/
[root@localhost ~]# ls /mnt/
lost+found
[root@localhost ~]# cat /etc/mtab
rootfs / rootfs rw 0 0
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
devtmpfs /dev devtmpfs rw,nosuid,size=240356k,nr_inodes=60089,mode=755 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,nodev,mode=755 0 0
tmpfs /sys/fs/cgroup tmpfs ro,nosuid,nodev,noexec,mode=755 0 0
cgroup /sys/fs/cgroup/systemd cgroup rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd 0 0
pstore /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
cgroup /sys/fs/cgroup/devices cgroup rw,nosuid,nodev,noexec,relatime,devices 0 0
cgroup /sys/fs/cgroup/perf_event cgroup rw,nosuid,nodev,noexec,relatime,perf_event 0 0
cgroup /sys/fs/cgroup/memory cgroup rw,nosuid,nodev,noexec,relatime,memory 0 0
cgroup /sys/fs/cgroup/net_cls,net_prio cgroup rw,nosuid,nodev,noexec,relatime,net_prio,net_cls 0 0
cgroup /sys/fs/cgroup/cpu,cpuacct cgroup rw,nosuid,nodev,noexec,relatime,cpuacct,cpu 0 0
cgroup /sys/fs/cgroup/pids cgroup rw,nosuid,nodev,noexec,relatime,pids 0 0
cgroup /sys/fs/cgroup/blkio cgroup rw,nosuid,nodev,noexec,relatime,blkio 0 0
cgroup /sys/fs/cgroup/hugetlb cgroup rw,nosuid,nodev,noexec,relatime,hugetlb 0 0
cgroup /sys/fs/cgroup/cpuset cgroup rw,nosuid,nodev,noexec,relatime,cpuset 0 0
cgroup /sys/fs/cgroup/freezer cgroup rw,nosuid,nodev,noexec,relatime,freezer 0 0
configfs /sys/kernel/config configfs rw,relatime 0 0
/dev/sda3 / xfs rw,relatime,attr2,inode64,noquota 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=30,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11725 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,relatime 0 0
mqueue /dev/mqueue mqueue rw,relatime 0 0
debugfs /sys/kernel/debug debugfs rw,relatime 0 0
/dev/sda1 /boot xfs rw,relatime,attr2,inode64,noquota 0 0
tmpfs /run/user/0 tmpfs rw,nosuid,nodev,relatime,size=50004k,mode=700 0 0
/dev/sdb1 /mnt ext4 rw,relatime,data=ordered 0 0
[root@localhost ~]# mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,size=240356k,nr_inodes=60089,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_prio,net_cls)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
configfs on /sys/kernel/config type configfs (rw,relatime)
/dev/sda3 on / type xfs (rw,relatime,attr2,inode64,noquota)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=30,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11725)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
mqueue on /dev/mqueue type mqueue (rw,relatime)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
/dev/sda1 on /boot type xfs (rw,relatime,attr2,inode64,noquota)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,size=50004k,mode=700)
/dev/sdb1 on /mnt type ext4 (rw,relatime,data=ordered)
[root@localhost ~]# umount /mnt
```

### 挂载选项

- -r：只读挂载
- -w：读写挂载，默认
- -n：禁止更新mtab，默认会更新mtab
- -t：文件系统类型，默认会根据blkid自动找到类型
- -L LABEL：以卷标挂载
- -U UUID：以UUID挂载
- -o：挂载后文件系统特性
    - async/sync 异步/同步：async默认性能好，先在内存中，稍后同步到磁盘
    - atime/noatime 更新atime/不更新atime：不更新atime性能好
    - diratime/nodiratime 开启目录更新atime/只关闭目录更新atime
    - remount：重新挂载
    - acl：启用acl功能，默认不启用
    - 已经挂载后修改为acl：mount -o remount,acl DEVICE MOUNT POINT
    - ro：只读
    - rw：读写，默认
    - dev/nodev：是否允许创建设备文件，默认允许
    - exec/noexec：是否允许运行此设备的可执行文件，默认允许
    - suid/nosuid：是否允许开启suid，默认允许
    - auto/noauto：是否允许mount -a挂载，默认允许
    - user/nouser：是否允许普通用户挂载，默认不允许
    - defaults：rw suid dev exec auto nouser async relatime
- --bind：将一个目录绑定到另一个目录上，实现临时访问
    - mount --bind /etc /mnt
    - umount /mnt
- 挂载光盘
    - mount -r /dev/cdrom /media/cdrom
- 挂载U盘
    - mount -o noexec DEVICE /media/udisk
- 无法卸载时，查看哪个进程占用
    1. lsof /mnt
    2. fuser -v /mnt
    3. 终止进程：fuser -km /mnt

```
[root@localhost ~]# yum -y install psmisc lsof
[root@localhost ~]# lsof /mydata/
COMMAND PID USER FD TYPE DEVICE SIZE/OFF NODE NAME
bash 1961 root cwd DIR 8,17 2048 2 /mydata
[root@localhost ~]# fuser -v /mydata/
                     USER PID ACCESS COMMAND
/mydata: root kernel mount /mydata
                     root 1961 ..c.. bash
[root@localhost ~]# fuser -km /mydata/
/mydata: 1961c
[root@localhost ~]# fuser -v /mydata/
                     USER PID ACCESS COMMAND
/mydata: root kernel mount /mydata
[root@localhost ~]# lsof /mydata/
[root@localhost ~]# umount /mydata/
```

- 挂载本地回环设备（iso镜像，img镜像）
    - mount -t iso9660 -o loop,ro ISOFILE /mnt
- 启用交换分区
    - 创建mkswap DEVICE
    - 启用：swapon DEVICE
    - 禁用：swapoff DEVICE
    - 启用所有在/etc/fstab上的swap设备：swapon -a

### /etc/fstab

- 设定除了/之外其他文件系统能开机时自动挂载
- /etc/fstab的6个字段
    1. 设备（伪文件系统，LABEL=，UUID=）
    2. 挂载点（swap为swap）
    3. 文件系统类型
    4. 挂载选项：defaults默认挂载，同时指定，以,隔开
    5. \# 转储频率：0 不备份，1每天备份，2隔天备份
    6. \# 自检次序：0 不自检，1-9按顺序自检
+ mount -a：将/etc/fstab中所有支持auto的设备挂载上

### df（disk free）

- 查看磁盘使用状态
- df -h以人类可读的模式查看block使用百分比
- df -l只显示本地文件系统
- df -i 查看inode使用百分比

### du（disk use）

- du -sh 目录 查看目录中所有文件的大小之和

```
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.1G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.3M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
[root@localhost ~]# df -i
Filesystem Inodes IUsed IFree IUse% Mounted on
/dev/sda3 62287360 33849 62253511 1% /
devtmpfs 60089 352 59737 1% /dev
tmpfs 62502 1 62501 1% /dev/shm
tmpfs 62502 377 62125 1% /run
tmpfs 62502 16 62486 1% /sys/fs/cgroup
/dev/sda1 102400 327 102073 1% /boot
tmpfs 62502 1 62501 1% /run/user/0
[root@localhost ~]# du -sh /usr
858M /usr
```

### 作业

1. 创建一个1G分区，格式化为ext4文件系统，block为2048K，预留2%管理空间，卷标为MYDATA，挂载至/mydata，要求禁止程序自动运行，不更新文件访问时间，可开机自动挂载
```
[root@localhost ~]# fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p

Disk /dev/sdb: 8589 MB, 8589934592 bytes, 16777216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x519a8c05

   Device Boot Start End Blocks Id System

Command (m for help): n
Partition type:
   p primary (0 primary, 0 extended, 4 free)
   e extended
Select (default p): p
Partition number (1-4, default 1): 1
First sector (2048-16777215, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-16777215, default 16777215): +1G
Partition 1 of type Linux and of size 1 GiB is set

Command (m for help): p

Disk /dev/sdb: 8589 MB, 8589934592 bytes, 16777216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x519a8c05

   Device Boot Start End Blocks Id System
/dev/sdb1 2048 2099199 1048576 83 Linux

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@localhost ~]# cat /proc/partitions
major minor #blocks name

   8 0 125829120 sda
   8 1 204800 sda1
   8 2 1048576 sda2
   8 3 124574720 sda3
   8 16 8388608 sdb
   8 17 1048576 sdb1
  11 0 1048575 sr0
[root@localhost ~]# mkdir /mydata
[root@localhost ~]# mke2fs -t ext4 -b 2048 -m 2 -L MYDATA /dev/sdb1
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=MYDATA
OS type: Linux
Block size=2048 (log=1)
Fragment size=2048 (log=1)
Stride=0 blocks, Stripe width=0 blocks
65536 inodes, 524288 blocks
10485 blocks (2.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=268959744
32 block groups
16384 blocks per group, 16384 fragments per group
2048 inodes per group
Superblock backups stored on blocks:
        16384, 49152, 81920, 114688, 147456, 409600, 442368

Allocating group tables: done
Writing inode tables: done
Creating journal (16384 blocks): done
Writing superblocks and filesystem accounting information: done

[root@localhost ~]# blkid /dev/sdb1
/dev/sdb1: LABEL="MYDATA" UUID="0602d2f5-7013-400c-9ddf-278116a5ce5a" TYPE="ext4"
[root@localhost ~]# mount -o noexec,noatime /dev/sdb1 /mydata
[root@localhost ~]# mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,size=240356k,nr_inodes=60089,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_prio,net_cls)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
configfs on /sys/kernel/config type configfs (rw,relatime)
/dev/sda3 on / type xfs (rw,relatime,attr2,inode64,noquota)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=30,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11725)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
mqueue on /dev/mqueue type mqueue (rw,relatime)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
/dev/sda1 on /boot type xfs (rw,relatime,attr2,inode64,noquota)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,size=50004k,mode=700)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
/dev/sdb1 on /mydata type ext4 (rw,noexec,noatime,data=ordered)
[root@localhost ~]# vim /etc/fstab
[root@localhost ~]# tail -1 /etc/fstab
LABEL=MYDATA /mydata ext4 defaults,noexec,noatime 0 0
[root@localhost ~]# umount /mydata/
[root@localhost ~]# mount -a
[root@localhost ~]# mount
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime)
proc on /proc type proc (rw,nosuid,nodev,noexec,relatime)
devtmpfs on /dev type devtmpfs (rw,nosuid,size=240356k,nr_inodes=60089,mode=755)
securityfs on /sys/kernel/security type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs on /dev/shm type tmpfs (rw,nosuid,nodev)
devpts on /dev/pts type devpts (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
tmpfs on /run type tmpfs (rw,nosuid,nodev,mode=755)
tmpfs on /sys/fs/cgroup type tmpfs (ro,nosuid,nodev,noexec,mode=755)
cgroup on /sys/fs/cgroup/systemd type cgroup (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
cgroup on /sys/fs/cgroup/devices type cgroup (rw,nosuid,nodev,noexec,relatime,devices)
cgroup on /sys/fs/cgroup/perf_event type cgroup (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup on /sys/fs/cgroup/memory type cgroup (rw,nosuid,nodev,noexec,relatime,memory)
cgroup on /sys/fs/cgroup/net_cls,net_prio type cgroup (rw,nosuid,nodev,noexec,relatime,net_prio,net_cls)
cgroup on /sys/fs/cgroup/cpu,cpuacct type cgroup (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
cgroup on /sys/fs/cgroup/pids type cgroup (rw,nosuid,nodev,noexec,relatime,pids)
cgroup on /sys/fs/cgroup/blkio type cgroup (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup on /sys/fs/cgroup/hugetlb type cgroup (rw,nosuid,nodev,noexec,relatime,hugetlb)
cgroup on /sys/fs/cgroup/cpuset type cgroup (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup on /sys/fs/cgroup/freezer type cgroup (rw,nosuid,nodev,noexec,relatime,freezer)
configfs on /sys/kernel/config type configfs (rw,relatime)
/dev/sda3 on / type xfs (rw,relatime,attr2,inode64,noquota)
systemd-1 on /proc/sys/fs/binfmt_misc type autofs (rw,relatime,fd=30,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11725)
hugetlbfs on /dev/hugepages type hugetlbfs (rw,relatime)
mqueue on /dev/mqueue type mqueue (rw,relatime)
debugfs on /sys/kernel/debug type debugfs (rw,relatime)
/dev/sda1 on /boot type xfs (rw,relatime,attr2,inode64,noquota)
tmpfs on /run/user/0 type tmpfs (rw,nosuid,nodev,relatime,size=50004k,mode=700)
binfmt_misc on /proc/sys/fs/binfmt_misc type binfmt_misc (rw,relatime)
/dev/sdb1 on /mydata type ext4 (rw,noexec,noatime,data=ordered)

```

2. 创建1Gswap，并启用，开机自动启用

```
[root@localhost ~]# fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).

Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): n
Partition type:
   p primary (1 primary, 0 extended, 3 free)
   e extended
Select (default p): p
Partition number (2-4, default 2): 2
First sector (2099200-16777215, default 2099200):
Using default value 2099200
Last sector, +sectors or +size{K,M,G} (2099200-16777215, default 16777215): +1G
Partition 2 of type Linux and of size 1 GiB is set

Command (m for help): t
Partition number (1,2, default 2): 2
Hex code (type L to list all codes): 82
Changed type of partition 'Linux' to 'Linux swap / Solaris'

Command (m for help): p

Disk /dev/sdb: 8589 MB, 8589934592 bytes, 16777216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x519a8c05

   Device Boot Start End Blocks Id System
/dev/sdb1 2048 2099199 1048576 83 Linux
/dev/sdb2 2099200 4196351 1048576 82 Linux swap / Solaris

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.

WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
The kernel still uses the old table. The new table will be used at
the next reboot or after you run partprobe(8) or kpartx(8)
Syncing disks.
[root@localhost ~]# cat /proc/partitions
major minor #blocks name

   8 0 125829120 sda
   8 1 204800 sda1
   8 2 1048576 sda2
   8 3 124574720 sda3
   8 16 8388608 sdb
   8 17 1048576 sdb1
  11 0 1048575 sr0
[root@localhost ~]# partx -a /dev/sdb
partx: /dev/sdb: error adding partition 1
[root@localhost ~]# cat /proc/partitions
major minor #blocks name

   8 0 125829120 sda
   8 1 204800 sda1
   8 2 1048576 sda2
   8 3 124574720 sda3
   8 16 8388608 sdb
   8 17 1048576 sdb1
   8 18 1048576 sdb2
  11 0 1048575 sr0
[root@localhost ~]# mkswap /dev/sdb2
Setting up swapspace version 1, size = 1048572 KiB
no label, UUID=9206fbdc-51d5-4988-8fdd-673898750290
[root@localhost ~]# blkid /dev/sdb2
/dev/sdb2: UUID="9206fbdc-51d5-4988-8fdd-673898750290" TYPE="swap"
[root@localhost ~]# free -m
              total used free shared buff/cache available
Mem: 488 77 255 4 155 379
Swap: 1023 0 1023
[root@localhost ~]# swapon /dev/sdb2
[root@localhost ~]# free -m
              total used free shared buff/cache available
Mem: 488 77 254 4 155 378
Swap: 2047 0 2047
[root@localhost ~]# vim /etc/fstab
[root@localhost ~]# tail -1 /etc/fstab
UUID=9206fbdc-51d5-4988-8fdd-673898750290 swap swap defaults 0 0
[root@localhost ~]# swapoff /dev/sdb2
[root@localhost ~]# free -m
              total used free shared buff/cache available
Mem: 488 77 255 4 155 378
Swap: 1023 0 1023
[root@localhost ~]# swapon -a
[root@localhost ~]# free -m
              total used free shared buff/cache available
Mem: 488 78 254 4 155 378
Swap: 2047 0 2047
```
