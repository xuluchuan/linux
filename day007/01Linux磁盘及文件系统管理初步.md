# Linux磁盘及文件系统管理初步

### 服务器最重要的4大件

1. CPU
2. 内存memory（RAM）
3. 磁盘io
4. 网卡io

### 硬盘接口类型

1. 家用
    + （1）IDE，并口，同一条线可以接多个设备，可以接2个，速率133MB/s，IOPS100
    + （2）SATA，串口，只能接一个盘，SATA3速率 6Gbps，IOPS100
2. 企业
    + （1）scsi，并口，窄带7个盘，宽带15个盘，速率640MB/s，IOPS200
    + （2）sas，串口，只能接一个盘，SAS3速率12Gbps，IOPS200
3. USB，3.0，480MB/s
4. 固态
    + （1） SATA口，600Mbps，IOPS 400
    + （2） PCI-E口（走北桥），IOPS 100000

### 硬盘选型场景

#### SATA,SAS,SSD 读写性能测试结果  

##### 测试工具 fio

```
以顺序读为例子，命令如下:fio -name iops -rw=read -bs=4k -runtime=60 -iodepth 32 -filename /dev/sda6 -ioengine libaio -direct=1
其中 rw=read表示随机读，bs=4k表示每次读4k,filename指定对应的分区，这里我是/dev/sda6,direct=1表示穿越linux的缓存
测试sata硬盘，sas硬盘，ssd硬盘的顺序读，随机读，顺序写，随机写的速度
```


##### 顺序读

```
测试命令:fio -name iops -rw=read -bs=4k -runtime=60 -iodepth 32 -filename /dev/sda6 -ioengine libaio -direct=1
SATA
Jobs: 1 (f=1): [R] [16.4% done] [124.1M/0K /s] [31.3K/0  iops] [eta 00m:51s]
SAS
Jobs: 1 (f=1): [R] [16.4% done] [190M/0K /s] [41.3K/0  iops] [eta 00m:51s]
SSD
Jobs: 1 (f=1): [R] [100.0% done] [404M/0K /s] [103K /0  iops] [eta 00m:00s]
可以看到 在对4KB数据包进行连续读的情况下:
SSD其速度可以达到404MB/S，IOPS达到103K/S
SAS其速度可以达到190MB/S，IOPS达到41K/S
SATA其速度可以达到124MB/S，IOPS达到31K/S
顺序读，SAS总体表现是SATA硬盘的1.3倍，SSD总体表现是sata硬盘的4倍。
```

##### 随机读

```
测试命令 fio -name iops -rw=randread -bs=4k -runtime=60 -iodepth 32 -filename /dev/sda6 -ioengine libaio -direct=1
SATA
Jobs: 1 (f=1): [r] [41.0% done] [466K/0K /s] [114 /0  iops] [eta 00m:36s]
SAS
Jobs: 1 (f=1): [r] [41.0% done] [1784K/0K /s] [456 /0  iops] [eta 00m:36s]
SSD
Jobs: 1 (f=1): [R] [100.0% done] [505M/0K /s] [129K /0  iops] [eta 00m:00s]
随机读，SAS总体表现是SATA硬盘的4倍，SSD总体表现是sata硬盘的一千多倍。
```

##### 顺序写

```
测试命令:fio -name iops -rw=write -bs=4k -runtime=60 -iodepth 32 -filename /dev/sda6 -ioengine libaio -direct=1
SATA
Jobs: 1 (f=1): [W] [21.3% done] [0K/124.9M /s] [0 /31.3K iops] [eta 00m:48s]
SAS
Jobs: 1 (f=1): [W] [21.3% done] [0K/190M /s] [0 /36.3K iops] [eta 00m:48s]
SSD
Jobs: 1 (f=1): [W] [100.0% done] [0K/592M /s] [0 /152K  iops] [eta 00m:00s]
同样的4KB数据包顺序写的情况下，SSD卡的成绩为592MB/S，IOPS为152K。而本地硬盘仅为118MB/S，IOPS仅为30290。
```

##### 随机写

```
测试命令: fio -name iops -rw=randwrite -bs=4k -runtime=60 -iodepth 32 -filename /dev/sda6 -ioengine libaio -direct=1
SATA
Jobs: 1 (f=1): [w] [100.0% done] [0K/548K /s] [0 /134  iops] [eta 00m:00s]
SAS
Jobs: 1 (f=1): [w] [100.0% done] [0K/2000K /s] [0 /512  iops] [eta 00m:00s]
SSD
Jobs: 1 (f=1): [W] [100.0% done] [0K/549M /s] [0 /140K  iops] [eta 00m:00s]
在接下来的4KB数据包随机写操作中，SSD卡再次展示了其高超的IO性能，高达549MB/S的随机写速率，IOPS高达140K。相比之下，本地硬盘的随机读写仅为548KB/S，IOPS为134。
```

#### 结论

1. SATA和SAS机械硬盘随机读写能力较弱，而顺序读写能力基本与SSD保持在同样的数量级，尤其是顺序读写大文件性能更佳
2. SSD的强项在于随机IO读写，基本可以媲美内存的访问速度，当然其顺序读写能力也处于比较高的水平
3. 受寻道时间这个机械因素影响，传统磁盘在随机读写场景，基本没有优势，由于磁盘读和写两个操作时间大概相同，所以随机读和随机写，单块磁盘的性能基本差不多
4. 对持续的大块写入请求，固态存储耗费擦除操作（耗时长）的时间大幅增加，而传统的磁盘却好相反，耗时长的寻道操作大幅减小，一次寻道，多次写入

### 机械硬盘工作方式

- 在真空中，马达带动同轴盘片高速旋转，机械手臂带动悬浮磁头在磁道工作
- 平均寻道时间：1.机械手臂的移动快 2.盘片转动快 笔记本5400转，台式机7200转
- 机械硬盘不能震动
- 磁道track：两个同心圆之间的部分
- 扇区sector：将磁道每512B划分为一个小扇区为存储单位
- 柱面cylinder：不同盘片同一编号的磁道组成的一个柱面，分区划分的最小单位
- 最外道的柱面组成的分区是速度最快的

### 设备文件

- 关联至设备的驱动程序，是设备的访问入口
- 特殊文件，没有大小，只有major主设备号（标明设备类型），minor次设备号（同种类型的不同设备）
- 手动创建设备文件mknod
- mknod [OPTION] NAME TYPE MAJOR MINOR
- 如：mknod /dev/testdev c 111
- -m 指明权限

### 设备文件名

- centos5 IDE接口为/dev/hd[a-z]
- 其他为/dev/sd[a-z]
- 引用设备的方式有：1.设备文件名2.卷标3.UUID
- 分区名/dev/sda#

### 磁盘分区

- 分为MBR GPT格式
- MBR 为主引导记录 master boot record
- 是第0柱面的第0扇区，分三部分
    1. 前446字节为BootLoader引导启动
    2. 中间64字节为fat分区表，16个字节为一个分区，最大4个分区
    3. 最后2个字节为有效标识，55AA有效
- 最多4个主分区
- 如果多于4个，需要3个主分区+1个扩展分区的方式，扩展分区可以分逻辑分区
- 主分区和扩展分区为1-4，逻辑分区为只能从5开始

### 磁盘分区管理命令fdisk

- fdisk -l [DEVICE] 列出设备分区信息
- fdisk DEVICE 管理分区
- 命令操作保存在内存中，只有w写入磁盘才生效
- m：获取帮助
- n：新建分区 (+10G,+扇区)
- d：删除分区
- p：显示当前分区
- l：列出所有id
- t：修改id
- w：保存设置
- cat /proc/partitions 看看内核是否识别了分区
- 已经挂载分区的磁盘创建新分区，内核可能无法立即识别，需要强制重读硬盘分区表
- centos5执行partprobe /dev/sda 6 7 执行 partx -a /dev/sda 或 kpartx -af /dev/sda，可能要执行两次
- 硬盘大于2T，使用parted创建GPT分区


### centos7 显示扇区，centos6显示柱面

```
[root@localhost ~]# fdisk -l
Disk /dev/sda: 128.8 GB, 128849018880 bytes, 251658240 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000ea9d5
   Device Boot Start End Blocks Id System
/dev/sda1 * 2048 411647 204800 83 Linux
/dev/sda2 411648 2508799 1048576 82 Linux swap / Solaris
/dev/sda3 2508800 251658239 124574720 83 Linux

[root@localhost ~]# fdisk -l
Disk /dev/sda: 128.8 GB, 128849018880 bytes
255 heads, 63 sectors/track, 15665 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x000b4799
   Device Boot Start End Blocks Id System
/dev/sda1 * 1 26 204800 83 Linux
Partition 1 does not end on cylinder boundary.
/dev/sda2 26 157 1048576 82 Linux swap / Solaris
Partition 2 does not end on cylinder boundary.
/dev/sda3 157 15666 124574720 83 Linux

```

- 创建分区

```
[root@localhost ~]# fdisk /dev/sdb
Welcome to fdisk (util-linux 2.23.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.
Device does not contain a recognized partition table
Building a new DOS disklabel with disk identifier 0x519a8c05.
Command (m for help): m
Command action
   a toggle a bootable flag
   b edit bsd disklabel
   c toggle the dos compatibility flag
   d delete a partition
   g create a new empty GPT partition table
   G create an IRIX (SGI) partition table
   l list known partition types
   m print this menu
   n add a new partition
   o create a new empty DOS partition table
   p print the partition table
   q quit without saving changes
   s create a new empty Sun disklabel
   t change a partition's system id
   u change display/entry units
   v verify the partition table
   w write table to disk and exit
   x extra functionality (experts only)
Command (m for help): n
Partition type:
   p primary (0 primary, 0 extended, 4 free)
   e extended
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-16777215, default 2048):
Using default value 2048
Last sector, +sectors or +size{K,M,G} (2048-16777215, default 16777215): +2G
Partition 1 of type Linux and of size 2 GiB is set
Command (m for help): p
Disk /dev/sdb: 8589 MB, 8589934592 bytes, 16777216 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x519a8c05
   Device Boot Start End Blocks Id System
/dev/sdb1 2048 4196351 2097152 83 Linux
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
   8 17 2097152 sdb1
  11 0 1048575 sr0
[root@localhost ~]# ls /dev/sdb*
/dev/sdb /dev/sdb1
```


### 文件系统

#### 文件系统特性

- 低格：分区之前，划分磁盘
- 高格：分区之后，对磁盘创建文件系统
- inode存放元数据，block存放数据
- inode中存放文件大小，权限，从属，时间戳，数据块指针，但不包括文件名（目录中block存放）
- block是磁盘数据最小分配单位，有1K，2K，4K等，2的n次方扇区
- 两种特殊文件不占用block
    1. 符号链接中inode的数据块指针存储的是真实文件的访问路径
    2. 设备文件中inode的数据块指针存储的是设备号
- 安装磁盘时应该预留空间，当磁盘空间满时可以操作转移
- inode/block比率设置
- 建立索引，位图索引
- 将磁盘分为块组，每个块组有块组描述符，界定范围
- 超级块superblock存放块组信息
- ls -i查看inode号
- stat查看inode存放的数据
- /var/log/messages 根inode→根block存放log的inode→log的inode→log的block存放messages的inode→messages的inode→messages的block
- free 看到的信息 buff/cache缓存inode和block
- 虚拟文件系统vfs是程序和真实文件系统的中间虚拟层

```
[root@localhost ~]# ls -li
total 8
134339459 -rw-------. 1 root root 1220 May 9 23:05 anaconda-ks.cfg
134354340 -rw-r--r-- 1 root root 115 May 28 20:02 sum.sh
[root@localhost ~]# stat sum.sh
  File: ‘sum.sh’
  Size: 115 Blocks: 8 IO Block: 4096 regular file
Device: 803h/2051d Inode: 134354340 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2018-05-28 20:02:26.569893642 +0800
Modify: 2018-05-28 20:02:24.382893642 +0800
Change: 2018-05-28 20:02:24.386893642 +0800
 Birth: -
[root@localhost ~]# free -m
              total used free shared buff/cache available
Mem: 488 71 317 4 100 389
Swap: 1023 0 1023
```

#### 文件系统分类

1. linux本地文件系统：ext2,ext3,ext4,xfs,reiserfs,btrfs
2. 光盘：iso9660
3. 网络：nfs,cifs
4. 集群：gfs2,ocfs2
5. 内核级别分布式文件系统：ceph
6. windows文件系统：vfat，ntfs
7. 伪文件系统：proc，sysfs，tmpfs，hugepagefs
8. unix文件系统：UFS,FFS,JFS
9. 交换分区swap
10. 用户空间分布式文件系统：mogilefs，moosefs，glusterfs，fastdfs

#### swap数据交换空间

- linux有虚拟内存机制，程序拿到的是虚拟内存
- 虚拟内存是划分一部分磁盘空间组成的内存
- 当内存不够用时，内核将最近最少使用的数据挪出放到swap硬盘上，当使用时再调走

#### 文件系统管理工具

1. 创建文件系统：mkfs.ext4，mkfs.xfs
2. 检测及修复：fsck.ext4,fsck.xfs
3. 查看属性： ext系列，dumpe2fs
4. 调整文件系统属性：ext4系列,tune2fs

#### 文件系统分类

- 有日志型文件系统
- 无日志型文件系统：ext2
- 日志区：元数据先放在日志区，当全部写入完成，再将元数据写入inode区，如果断电没写入完，下次开机会检查日志中的元数据

#### 软链接与硬链接

- 硬链接：两个路径指向同一个inode
- 软链接：inode指向另一个路径

##### 硬链接特性

1. 不支持目录
2. 不能跨文件系统
3. 创建硬链接会增加inode引用计数（ls -l可以看到），当此计数为0时此文件被删除
4. 硬链接的文件大小相同
6. 创建硬链接：ln 源文件 硬链接文件

##### 软链接特性

1. 符号链接与源文件是独立文件，inode不同
2. 支持目录
3. 可以跨文件系统
4. 删除符号链接，不影响源文件，删除源文件，符号链接会失效
5. 创建符号链接，不会影响文件的inode引用计数
6. 软链接的文件大小是其指向文件路径的字符串的字节数
7. 软链接的权限是777.保证所有人可以访问到软链接，但文件真实权限是其指向的源文件的权限
8. 创建软链接：ln -s 源文件 软链接文件

```
[root@localhost ~]# ln sum.sh sum2.sh
[root@localhost ~]# ls -li
total 12
134339459 -rw-------. 1 root root 1220 May 9 23:05 anaconda-ks.cfg
134354340 -rw-r--r-- 2 root root 115 May 28 20:02 sum2.sh
134354340 -rw-r--r-- 2 root root 115 May 28 20:02 sum.sh
[root@localhost ~]# ls
anaconda-ks.cfg sum2.sh sum.sh
[root@localhost ~]# rm -f sum2.sh
[root@localhost ~]# ls -li
total 8
134339459 -rw-------. 1 root root 1220 May 9 23:05 anaconda-ks.cfg
134354340 -rw-r--r-- 1 root root 115 May 28 20:02 sum.sh
[root@localhost ~]# ln -s sum.sh sum2.sh
[root@localhost ~]# ls -li
total 8
134339459 -rw-------. 1 root root 1220 May 9 23:05 anaconda-ks.cfg
134339516 lrwxrwxrwx 1 root root 6 May 31 17:52 sum2.sh -> sum.sh
134354340 -rw-r--r-- 1 root root 115 May 28 20:02 sum.sh
[root@localhost ~]# rm -f sum.sh
[root@localhost ~]# ls -li
total 4
134339459 -rw-------. 1 root root 1220 May 9 23:05 anaconda-ks.cfg
134339516 lrwxrwxrwx 1 root root 6 May 31 17:52 sum2.sh -> sum.sh
```

