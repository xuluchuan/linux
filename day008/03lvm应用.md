# lvm2

### lvm2简介

- logic volume manager 逻辑卷管理器2
- 内核dm （device mapper）模块，设备映射内核模块
- 将1个或多个底层块设备组织成一个逻辑设备的模块
- 底层为pv（physical volume）物理卷
- 中间层为vg（volume group）卷组，可将多个pv组织成1个vg，以pe（physical extend）物理盘区为单位（默认4M）
- 上层为lv（logical volume）逻辑卷，可将1个vg划分为多个lv，一个lv是一个独立的文件系统，以le（logical extend）逻辑盘区为单位
- lvm特点：当磁盘的增长不可预测时，可以方便扩展，缩减比较危险，因为lvm不容易修复
- 真正文件在/dev/dm-#，符号链接在/dev/mapper/VG_NAME-LV_NAME，或/dev/VG_NAME/LV_NAME
- 企业实际应用是底层硬raid，上层lvm，全网备份

### lvm操作步骤

#### 创建物理卷

- 物理卷可以创建在磁盘，分区，raid上
- 需要将分区调整为8e分区
- pvs 简要显示
- pvdisplay [DEVICE] 详细显示
- pvcreate DEVICE 创建pv
- pvremove DEVICE 移除pv

```
[root@localhost ~]# yum -y install lvm2
[root@localhost ~]# fdisk /dev/sdb
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF disklabel
Building a new DOS disklabel with disk identifier 0xbe2c440d.
Changes will remain in memory only, until you decide to write them.
After that, of course, the previous content won't be recoverable.

Warning: invalid flag 0x0000 of partition table 4 will be corrected by w(rite)

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdb: 42.9 GB, 42949672960 bytes
255 heads, 63 sectors/track, 5221 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbe2c440d

   Device Boot Start End Blocks Id System

Command (m for help): n
Command action
   e extended
   p primary partition (1-4)
p
Partition number (1-4): 1
First cylinder (1-5221, default 1):
Using default value 1
Last cylinder, +cylinders or +size{K,M,G} (1-5221, default 5221): +5G

Command (m for help): n
Command action
   e extended
   p primary partition (1-4)
p
Partition number (1-4): 2
First cylinder (655-5221, default 655):
Using default value 655
Last cylinder, +cylinders or +size{K,M,G} (655-5221, default 5221): +5G

Command (m for help): n
Command action
   e extended
   p primary partition (1-4)
p
Partition number (1-4): 3
First cylinder (1309-5221, default 1309):
Using default value 1309
Last cylinder, +cylinders or +size{K,M,G} (1309-5221, default 5221): +5G

Command (m for help): p

Disk /dev/sdb: 42.9 GB, 42949672960 bytes
255 heads, 63 sectors/track, 5221 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbe2c440d

   Device Boot Start End Blocks Id System
/dev/sdb1 1 654 5253223+ 83 Linux
/dev/sdb2 655 1308 5253255 83 Linux
/dev/sdb3 1309 1962 5253255 83 Linux

Command (m for help): t
Partition number (1-4): 1
Hex code (type L to list codes): 8e
Changed system type of partition 1 to 8e (Linux LVM)

Command (m for help): t
Partition number (1-4): 2
Hex code (type L to list codes): 8e
Changed system type of partition 2 to 8e (Linux LVM)

Command (m for help): t
Partition number (1-4): 3
Hex code (type L to list codes): 8e
Changed system type of partition 3 to 8e (Linux LVM)

Command (m for help): p

Disk /dev/sdb: 42.9 GB, 42949672960 bytes
255 heads, 63 sectors/track, 5221 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0xbe2c440d

   Device Boot Start End Blocks Id System
/dev/sdb1 1 654 5253223+ 8e Linux LVM
/dev/sdb2 655 1308 5253255 8e Linux LVM
/dev/sdb3 1309 1962 5253255 8e Linux LVM

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
[root@localhost ~]# cat /proc/partitions
major minor #blocks name

   8 16 41943040 sdb
   8 17 5253223 sdb1
   8 18 5253255 sdb2
   8 19 5253255 sdb3
   8 0 125829120 sda
   8 1 204800 sda1
   8 2 1048576 sda2
   8 3 124574720 sda3
[root@localhost ~]# pvcreate /dev/sdb1
  Physical volume "/dev/sdb1" successfully created
[root@localhost ~]# pvcreate /dev/sdb2
  Physical volume "/dev/sdb2" successfully created
[root@localhost ~]# pvcreate /dev/sdb3
  Physical volume "/dev/sdb3" successfully created
[root@localhost ~]# pvs
  PV VG Fmt Attr PSize PFree
  /dev/sdb1 lvm2 ---- 5.01g 5.01g
  /dev/sdb2 lvm2 ---- 5.01g 5.01g
  /dev/sdb3 lvm2 ---- 5.01g 5.01g
[root@localhost ~]# pvdisplay
  "/dev/sdb1" is a new physical volume of "5.01 GiB"
  --- NEW Physical volume ---
  PV Name /dev/sdb1
  VG Name
  PV Size 5.01 GiB
  Allocatable NO
  PE Size 0
  Total PE 0
  Free PE 0
  Allocated PE 0
  PV UUID ehjIQ7-CpOY-KUAk-TPlH-aUQx-3MRt-BIYlD0

  "/dev/sdb2" is a new physical volume of "5.01 GiB"
  --- NEW Physical volume ---
  PV Name /dev/sdb2
  VG Name
  PV Size 5.01 GiB
  Allocatable NO
  PE Size 0
  Total PE 0
  Free PE 0
  Allocated PE 0
  PV UUID MnVrEC-P1jD-p73i-WKYm-c25f-3R7E-f0yd3x

  "/dev/sdb3" is a new physical volume of "5.01 GiB"
  --- NEW Physical volume ---
  PV Name /dev/sdb3
  VG Name
  PV Size 5.01 GiB
  Allocatable NO
  PE Size 0
  Total PE 0
  Free PE 0
  Allocated PE 0
  PV UUID vIvEnY-HJg8-OCkp-Kkdc-6hY9-R6r5-NCKJBH
```

#### 创建卷组vg

- vgcreate VG_NAME DEVICE..
- -s 指明pe大小，默认4Mpe

```
[root@localhost ~]# vgcreate myvg /dev/sdb1 /dev/sdb2
  Volume group "myvg" successfully created
[root@localhost ~]# vgs
  VG #PV #LV #SN Attr VSize VFree
  myvg 2 0 0 wz--n- 10.02g 10.02g
[root@localhost ~]# vgdisplay
  --- Volume group ---
  VG Name myvg
  System ID
  Format lvm2
  Metadata Areas 2
  Metadata Sequence No 1
  VG Access read/write
  VG Status resizable
  MAX LV 0
  Cur LV 0
  Open LV 0
  Max PV 0
  Cur PV 2
  Act PV 2
  VG Size 10.02 GiB
  PE Size 4.00 MiB
  Total PE 2564
  Alloc PE / Size 0 / 0
  Free PE / Size 2564 / 10.02 GiB
  VG UUID L7DoFn-jhy1-yBbG-VvCf-Zoer-zIcy-BtlFYA
```

#### 扩展卷组vg

- vgextend VG_NAME DEVICE..

```
[root@localhost ~]# vgextend myvg /dev/sdb3
  Volume group "myvg" successfully extended
[root@localhost ~]# vgs
  VG #PV #LV #SN Attr VSize VFree
  myvg 3 0 0 wz--n- 15.02g 15.02g
```

#### 缩减卷组vg

+ 1.移除物理卷 pvmove DEVICE
+ 2.缩减 vgreduce VG_NAME DEVICE

```
[root@localhost ~]# pvmove /dev/sdb3
  No data to move for myvg
[root@localhost ~]# vgreduce myvg /dev/sdb3
  Removed "/dev/sdb3" from volume group "myvg"
[root@localhost ~]# vgs
  VG #PV #LV #SN Attr VSize VFree
  myvg 2 0 0 wz--n- 10.02g 10.02g
```

#### 创建逻辑卷lv

- lvcreate -L #[MGT] -n LV_NAME VG_NAME

```
[root@localhost ~]# lvcreate -L 5G -n mylv myvg
  Logical volume "mylv" created.
[root@localhost ~]# lvs
  LV VG Attr LSize Pool Origin Data% Meta% Move Log Cpy%Sync Convert
  mylv myvg -wi-a----- 5.00g
[root@localhost ~]# ls /dev/mapper/
control myvg-mylv
[root@localhost ~]# ls -l /dev/mapper/myvg-mylv
lrwxrwxrwx 1 root root 7 Jun 6 14:35 /dev/mapper/myvg-mylv -> ../dm-0
[root@localhost ~]# ls -l /dev/myvg/mylv
lrwxrwxrwx 1 root root 7 Jun 6 14:35 /dev/myvg/mylv -> ../dm-0
```

#### 格式化和挂载

```
[root@localhost ~]# mkfs.ext4 /dev/myvg/mylv
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
327680 inodes, 1310720 blocks
65536 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=1342177280
40 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736

Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 27 mounts or
180 days, whichever comes first. Use tune2fs -c or -i to override.
[root@localhost ~]# blkid /dev/myvg/mylv
/dev/myvg/mylv: UUID="94c20566-c4c6-4928-923c-e6f01c840a2d" TYPE="ext4"
[root@localhost ~]# vim /etc/fstab
[root@localhost ~]# tail -1 /etc/fstab
UUID=94c20566-c4c6-4928-923c-e6f01c840a2d /mnt ext4 defaults,acl 0 0
[root@localhost ~]# mount -a
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 117G 871M 111G 1% /
tmpfs 245M 0 245M 0% /dev/shm
/dev/sda1 190M 32M 149M 18% /boot
/dev/mapper/myvg-mylv
                      4.8G 10M 4.6G 1% /mnt
[root@localhost ~]# cp /etc/fstab /mnt/
```

#### 扩展lv（联机）

- 1.扩展物理边界 lvextend -L [+]#[MGT] /dev/VG_NAME/LV_NAME
- 2.扩展逻辑边界 resize2fs /dev/VG_NAME/LV_NAME

```
[root@localhost ~]# lvextend -L 8G /dev/myvg/mylv
  Size of logical volume myvg/mylv changed from 5.00 GiB (1280 extents) to 8.00 GiB (2048 extents).
  Logical volume mylv successfully resized.
[root@localhost ~]# resize2fs /dev/myvg/mylv
resize2fs 1.41.12 (17-May-2010)
Filesystem at /dev/myvg/mylv is mounted on /mnt; on-line resizing required
old desc_blocks = 1, new_desc_blocks = 1
Performing an on-line resize of /dev/myvg/mylv to 2097152 (4k) blocks.
The filesystem on /dev/myvg/mylv is now 2097152 blocks long.

[root@localhost ~]# lvs
  LV VG Attr LSize Pool Origin Data% Meta% Move Log Cpy%Sync Convert
  mylv myvg -wi-ao---- 8.00g
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 117G 871M 111G 1% /
tmpfs 245M 0 245M 0% /dev/shm
/dev/sda1 190M 32M 149M 18% /boot
/dev/mapper/myvg-mylv
                      7.8G 12M 7.4G 1% /mnt
[root@localhost ~]# tail -1 /mnt/fstab
UUID=94c20566-c4c6-4928-923c-e6f01c840a2d /mnt ext4 defaults,acl 0 0
```

#### 缩减lv（不建议缩减，卸载）

1. 卸载文件系统
2. 强制检测 e2fsck -f /dev/VG_NAME/LV_NAME
3. 修改逻辑边界 resize2fs /dev/VG_NAME/LV_NAME #[MGT]
4. 修改物理边界 lvreduce -L [-]#[MGT] /dev/VG_NAME/LV_NAME
5. 挂载

```
[root@localhost ~]# umount /mnt
[root@localhost ~]# e2fsck -f /dev/myvg/mylv
e2fsck 1.41.12 (17-May-2010)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/myvg/mylv: 12/524288 files (0.0% non-contiguous), 68560/2097152 blocks
[root@localhost ~]# resize2fs /dev/myvg/mylv 5G
resize2fs 1.41.12 (17-May-2010)
Resizing the filesystem on /dev/myvg/mylv to 1310720 (4k) blocks.
The filesystem on /dev/myvg/mylv is now 1310720 blocks long.
[root@localhost ~]# lvreduce -L 5G /dev/myvg/mylv
  WARNING: Reducing active logical volume to 5.00 GiB.
  THIS MAY DESTROY YOUR DATA (filesystem etc.)
Do you really want to reduce myvg/mylv? [y/n]: y
  Size of logical volume myvg/mylv changed from 8.00 GiB (2048 extents) to 5.00 GiB (1280 extents).
  Logical volume mylv successfully resized.
[root@localhost ~]# mount -a
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 117G 871M 111G 1% /
tmpfs 245M 0 245M 0% /dev/shm
/dev/sda1 190M 32M 149M 18% /boot
/dev/mapper/myvg-mylv
                      4.8G 10M 4.6G 1% /mnt
[root@localhost ~]# lvs
  LV VG Attr LSize Pool Origin Data% Meta% Move Log Cpy%Sync Convert
  mylv myvg -wi-ao---- 5.00g
[root@localhost ~]# tail -1 /mnt/fstab
UUID=94c20566-c4c6-4928-923c-e6f01c840a2d /mnt ext4 defaults,acl 0 0
```

#### lvm快照

- 原理：快照lv只监控原lv的元数据变化情况，如有变化，仅存储发生变化的文件
- 特点：快照lv和原lv必须在同一个vg中，快照lv大小可以比原lv小
- 用途：热拷贝，拷贝某个时刻的快照，就是拷贝某个时刻的内容，之后的变化不会拷贝
- 创建：lvcreate -L #[MGT] -p r -s -n SNAPSHOT_LV_NAME /dev/VG_NAME/ORIGINAL_LV_NAME
- 可以挂载为只读访问 mount -r
- 热拷贝结束后卸载 umount
- 删除快照 lvremove /dev/VG_NAME/SNAPSHOT_LV_NAME
  
```
[root@localhost ~]# lvcreate -L 1G -p r -s -n snap_20180606_1500_mylv /dev/myvg/mylv
  Logical volume "snap_20180606_1500_mylv" created.
[root@localhost ~]# mount -r /dev/myvg/snap_20180606_1500_mylv /media
[root@localhost ~]# ls /media/
fstab lost+found
[root@localhost ~]# echo "hello" >> /mnt/fstab
[root@localhost ~]# tail -1 /media/fstab
UUID=94c20566-c4c6-4928-923c-e6f01c840a2d /mnt ext4 defaults,acl 0 0
[root@localhost ~]# lvs
  LV VG Attr LSize Pool Origin Data% Meta% Move Log Cpy%Sync Convert
  mylv myvg owi-aos--- 5.00g
  snap_20180606_1500_mylv myvg sri-a-s--- 1.00g mylv 0.00
[root@localhost ~]# lvremove /dev/myvg/snap_20180606_1500_mylv
Do you really want to remove active logical volume snap_20180606_1500_mylv? [y/n]: y
  Logical volume "snap_20180606_1500_mylv" successfully removed
[root@localhost ~]# lvs
  LV VG Attr LSize Pool Origin Data% Meta% Move Log Cpy%Sync Convert
  mylv myvg -wi-ao---- 5.00g
```

#### 删除lvm

- 先卸载，后lvremove，后vgremove，后pvremove

```
[root@localhost ~]# umount /mnt
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 117G 871M 111G 1% /
tmpfs 245M 0 245M 0% /dev/shm
/dev/sda1 190M 32M 149M 18% /boot
[root@localhost ~]# lvremove /dev/myvg/mylv
Do you really want to remove active logical volume mylv? [y/n]: y
  Logical volume "mylv" successfully removed
[root@localhost ~]# vgremove myvg
  Volume group "myvg" successfully removed
[root@localhost ~]# pvs
  PV VG Fmt Attr PSize PFree
  /dev/sdb1 lvm2 ---- 5.01g 5.01g
  /dev/sdb2 lvm2 ---- 5.01g 5.01g
  /dev/sdb3 lvm2 ---- 5.01g 5.01g
[root@localhost ~]# vgs
[root@localhost ~]# lvs
[root@localhost ~]# pvremove /dev/sdb1
  Labels on physical volume "/dev/sdb1" successfully wiped
[root@localhost ~]# pvremove /dev/sdb2
  Labels on physical volume "/dev/sdb2" successfully wiped
[root@localhost ~]# pvremove /dev/sdb3
  Labels on physical volume "/dev/sdb3" successfully wiped
[root@localhost ~]# pvs
```

#### dd命令

- 文件底层复制，块复制，速度快
- dd if=/PATH/FROM/SRC of=/PATH/TO/DESC bs=# count=#
- 用途1：磁盘拷贝，dd if=/dev/sda of=/dev/sdb
- 用途2：备份mbr，dd if=/dev/sda of=/tmp/mbr.bak bs=512 count=1
- 用途3：创建新文件 dd if=/dev/zero of=/tmp/new_100M_file bs=1M count=100


