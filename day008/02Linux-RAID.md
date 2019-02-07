# RAID

### RAID 简介

- Redundant Arrays of Independent （Inexpensive）Disks
- 独立（廉价）磁盘冗余阵列
- iops可以达到数万的磁盘是PCE-E的固态盘阵列
- 特点：1.提高io能力（并行读写）2.提高耐用性（冗余）
- 级别：多块磁盘组织在一起的工作方式有所不同
- 实现方式：
    1. 硬raid之外接式磁盘阵列：扩展卡提供适配
    2. 硬raid之内接式磁盘阵列：主板集成raid控制器
    3. 软raid：软件方式实现，不推荐
- 购买raid控制器：看内存大小，看断电后供电

### RAID0

- 条带卷：切割成chunk后分别存入，适用于对数据冗余要求不高的场景，如缓存服务器
- 1.读写性能提升
- 2.可用空间为 N*min(S1,S2,...)
- 3.无冗余
- 4.最少2块磁盘，可以2+

### RAID1

- 镜像卷：将同一数据分别存入两份，适用于对冗余要求高，对性能要求不高的场景，如/分区
- 1.读性能提升，写性能略有下降
- 2.可用空间 1*min(S1,S2,...)
- 3.有冗余能力
- 4.最少2块磁盘，可以2+

### RADI4

- 至少3块盘，数据切割存入2块盘，1块盘存异或校验码
- 1.允许坏1块盘，可以降级工作，要尽快更换，采用监控和热备的方式
- 2.压力瓶颈在校验盘

### RAID5

- 至少3块盘，数据切割存入，轮流写入校验码，采用左对称
- 1.读写性能提升
- 2.可用空间为 (N-1)*min(S1,S1,...)
- 3.有冗余能力，允许坏1块盘
- 4.最少3块磁盘，可以3+

### RAID6

- 至少4块盘，数据切割存入，轮流写入校验码到2块盘
- 1.读写性能提升
- 2.可用空间为(N-2)*min(S1,S2,..)
- 3.有冗余，允许坏2块盘
- 4.最少4块盘，可以4+

### RAID10

- 至少4块盘，底层两两一组组成镜像卷，上层为条带卷
- 1.读写性能提升
- 2.可用空间为N*min(S1,S2,..)/2
- 3.有冗余，但每个镜像卷最多只允许坏1块
- 4.最少4块盘，可以4+

### RAID50

- 至少6块盘，底层每3个一组组成RAID5，上层为条带卷
- 1.有冗余，但每个RAID5组最多坏1块

### RAID7

### JBOD

- Just a Bunch Of Disks
- 将多块磁盘空间合并为一个大的连续空间使用
- 可用空间为 sum(S1,S2,..)

### 常见

- RAID0 RAID1 RAID5 RAID10 RAID50 JBOD

### 软RAID

- centos6软RAID实现方式是通过内核模块md（multi devices）实现的
- 模式化工具为mdadm
- 用法为：mdadm [mode] <raiddevice> [options] <component-devices>
- 支持raid为：linear（jbod） 0 1 4 5 6 10
- mode有创建-C 装配-A 监控-F 管理-f -r -a -D -S

#### 创建

- -C 
    + 1.-n#：n个块设备
    + 2.-l#：RAID级别
    + 3.-a [yes|no] ：是否自动创建RAID 设备的设备文件
    + 4.-c CHUNK-SIZE：志明块大小，默认为512K
    + 5.-x#：指明空闲盘个数
    + 注意：需要将硬盘分区格式调整为fd模式
    + cat /proc/mdstat 查看md类型设备状态
    + raid设备为/dev/md#
    + watch -n1 cat /proc/mdstat 每隔1S查看命令执行

```
[root@localhost ~]# fdisk /dev/sdb
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklab el
Building a new DOS disklabel with disk identifier 0x71cebcf5.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdb: 17.2 GB, 17179869184 bytes
255 heads, 63 sectors/track, 2088 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x71cebcf5

   Device Boot Start End Blocks Id System

Command (m for help): n
Command action
   e extended
   p primary partition (1-4)
1
Invalid partition number for type `1'
Command action
   e extended
   p primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-2088, default 1):
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-2088, default 2088): +4G

Command (m for help): t
Selected partition 1
Hex code (type L to list codes): fd
Changed system type of partition 1 to fd (Linux raid autodetect)

Command (m for help): n
Command action
   e extended
   p primary partition (1-4)
p
Partition number (1-4): 2
First cylinder (524-2088, default 524):
Using default value 524
Last cylinder, +cylinders or +size{K,M,G} (524-2088, default 2088): +4G

Command (m for help): t
Partition number (1-4): 2
Hex code (type L to list codes): fd
Changed system type of partition 2 to fd (Linux raid autodetect)

Command (m for help): p

Disk /dev/sdb: 17.2 GB, 17179869184 bytes
255 heads, 63 sectors/track, 2088 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x71cebcf5

   Device Boot Start End Blocks Id System
/dev/sdb1 1 523 4200966 fd Linux raid autodetect
/dev/sdb2 524 1046 4200997+ fd Linux raid autodetect

Command (m for help): n
Command action
   e extended
   p primary partition (1-4)
p
Partition number (1-4): 3
First cylinder (1047-2088, default 1047):
Using default value 1047
Last cylinder, +cylinders or +size{K,M,G} (1047-2088, default 2088): +4G

Command (m for help): t
Partition number (1-4): 3
Hex code (type L to list codes): fd
Changed system type of partition 3 to fd (Linux raid autodetect)

Command (m for help): n
Command action
   e extended
   p primary partition (1-4)
p
Selected partition 4
First cylinder (1570-2088, default 1570):
Using default value 1570
Last cylinder, +cylinders or +size{K,M,G} (1570-2088, default 2088):
Using default value 2088

Command (m for help): p

Disk /dev/sdb: 17.2 GB, 17179869184 bytes
255 heads, 63 sectors/track, 2088 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x71cebcf5

   Device Boot Start End Blocks Id System
/dev/sdb1 1 523 4200966 fd Linux raid autodetect
/dev/sdb2 524 1046 4200997+ fd Linux raid autodetect
/dev/sdb3 1047 1569 4200997+ fd Linux raid autodetect
/dev/sdb4 1570 2088 4168867+ 83 Linux

Command (m for help): t
Partition number (1-4): 4
Hex code (type L to list codes): fd
Changed system type of partition 4 to fd (Linux raid autodetect)

Command (m for help): p

Disk /dev/sdb: 17.2 GB, 17179869184 bytes
255 heads, 63 sectors/track, 2088 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x71cebcf5

   Device Boot Start End Blocks Id System
/dev/sdb1 1 523 4200966 fd Linux raid autodetect
/dev/sdb2 524 1046 4200997+ fd Linux raid autodetect
/dev/sdb3 1047 1569 4200997+ fd Linux raid autodetect
/dev/sdb4 1570 2088 4168867+ fd Linux raid autodetect

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@localhost ~]# cat /proc/mdstat
Personalities :
unused devices: <none>
[root@localhost ~]# mdadm -C /dev/md0 -a yes -n 3 -x 1 -l 5 -c 256K /dev/sdb{1,2 ,3,4}
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
[root@localhost ~]# watch -n1 cat /proc/mdstat
[root@localhost ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb3[4] sdb4[3](S) sdb2[1] sdb1[0]
      8329216 blocks super 1.2 level 5, 256k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>
[root@localhost ~]# mkfs.ext4 /dev/md0
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=64 blocks, Stripe width=128 blocks
521216 inodes, 2082304 blocks
104115 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2134900736
64 block groups
32768 blocks per group, 32768 fragments per group
8144 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 39 mounts or
180 days, whichever comes first. Use tune2fs -c or -i to override.
[root@localhost ~]# blkid /dev/md0
/dev/md0: UUID="78d374e6-3abb-4aad-8016-81627144cc1c" TYPE="ext4"
[root@localhost ~]# vim /etc/fstab
[root@localhost ~]# tail -1 /etc/fstab
UUID=78d374e6-3abb-4aad-8016-81627144cc1c /mnt ext4 defaults,acl,noatime,noexec,nodev,nosuid 0 0
[root@localhost ~]# mount -a
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 117G 863M 111G 1% /
tmpfs 245M 0 245M 0% /dev/shm
/dev/sda1 190M 32M 149M 18% /boot
/dev/md0 7.7G 18M 7.3G 1% /mnt
```

#### 管理

- -f 标记为错误
- -D 查看详细信息
- -r 移除
- -a 添加
- -S 停用

```
[root@localhost ~]# mdadm /dev/md0 -f /dev/sdb4
mdadm: set /dev/sdb4 faulty in /dev/md0
[root@localhost ~]# !watch
watch -n1 cat /proc/mdstat
[root@localhost ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdb3[4] sdb4[3](F) sdb2[1] sdb1[0]
      8329216 blocks super 1.2 level 5, 256k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>
[root@localhost ~]# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Tue Jun 5 19:41:12 2018
     Raid Level : raid5
     Array Size : 8329216 (7.94 GiB 8.53 GB)
  Used Dev Size : 4164608 (3.97 GiB 4.26 GB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Jun 5 19:52:37 2018
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

           Name : localhost.localdomain:0 (local to host localhost.localdomain)
           UUID : b97cebc1:ac7f18d4:18ef0aa3:e0d1f5c7
         Events : 19

    Number Major Minor RaidDevice State
       0 8 17 0 active sync /dev/sdb1
       1 8 18 1 active sync /dev/sdb2
       4 8 19 2 active sync /dev/sdb3

       3 8 20 - faulty /dev/sdb4
[root@localhost ~]# mdadm /dev/md0 -f /dev/sdb3
mdadm: set /dev/sdb3 faulty in /dev/md0
[root@localhost ~]# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Tue Jun 5 19:41:12 2018
     Raid Level : raid5
     Array Size : 8329216 (7.94 GiB 8.53 GB)
  Used Dev Size : 4164608 (3.97 GiB 4.26 GB)
   Raid Devices : 3
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Jun 5 19:55:45 2018
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

           Name : localhost.localdomain:0 (local to host localhost.localdomain)
           UUID : b97cebc1:ac7f18d4:18ef0aa3:e0d1f5c7
         Events : 21

    Number Major Minor RaidDevice State
       0 8 17 0 active sync /dev/sdb1
       1 8 18 1 active sync /dev/sdb2
       4 0 0 4 removed

       3 8 20 - faulty /dev/sdb4
       4 8 19 - faulty /dev/sdb3
[root@localhost ~]# !watch
watch -n1 cat /proc/mdstat
[root@localhost ~]# cd /mnt/
[root@localhost mnt]# ls
lost+found
[root@localhost mnt]# cd
[root@localhost ~]# mdadm /dev/md0 -r /dev/sdb4
mdadm: hot removed /dev/sdb4 from /dev/md0
[root@localhost ~]# mdadm /dev/md0 -r /dev/sdb3
mdadm: hot removed /dev/sdb3 from /dev/md0
[root@localhost ~]# mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Tue Jun 5 19:41:12 2018
     Raid Level : raid5
     Array Size : 8329216 (7.94 GiB 8.53 GB)
  Used Dev Size : 4164608 (3.97 GiB 4.26 GB)
   Raid Devices : 3
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Tue Jun 5 19:57:05 2018
          State : clean, degraded
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 256K

           Name : localhost.localdomain:0 (local to host localhost.localdomain)
           UUID : b97cebc1:ac7f18d4:18ef0aa3:e0d1f5c7
         Events : 23

    Number Major Minor RaidDevice State
       0 8 17 0 active sync /dev/sdb1
       1 8 18 1 active sync /dev/sdb2
       4 0 0 4 removed
[root@localhost ~]# mdadm /dev/md0 -a /dev/sdb3
mdadm: added /dev/sdb3
[root@localhost ~]# !watch
watch -n1 cat /proc/mdstat
[root@localhost ~]# mdadm /dev/md0 -a /dev/sdb4
mdadm: added /dev/sdb4
[root@localhost ~]# watch -n1 cat /proc/mdstat
[root@localhost ~]# umount /mnt
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 117G 863M 111G 1% /
tmpfs 245M 0 245M 0% /dev/shm
/dev/sda1 190M 32M 149M 18% /boot
[root@localhost ~]# mdadm -S /dev/md0
mdadm: stopped /dev/md0
[root@localhost ~]# mdadm -D /dev/md0
mdadm: cannot open /dev/md0: No such file or directory
[root@localhost ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
unused devices: <none>
```

#### 备份

- 即使有RAID设备，也需要进行文件备份
