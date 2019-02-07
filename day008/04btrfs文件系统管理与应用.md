# btrfs

- b-tree file system butter better
- 核心特性：
    1. 多物理卷支持：可由多个底层物理卷组成，支持RAID，可以联机添加，删除，修改
    2. 写时复制：cow，通过复制，更新，替换指针的方式，而非就地更新，可以文件快照，快速恢复
    3. 数据及元数据校验码：checksum
    4. 子卷：subvolume
    5. 快照：支持快照的快照，增量快照
    6. 透明压缩：节约空间，但消耗cpu

### 创建btrfs

- mkfs.btrfs格式化
    - -L LABEL：指明label
    - -d <type>：为数据组织方式指明级别 raid0 radi1 raid5 raid6 raid10 single
    - -m <profile>：为元数据组织方式指明级别 raid0 radi1 raid5 raid6 raid10 single dup
    - -O <pattern> ：list-all 可以列出所有特性
- 查看 btrfs filesystem show [--mounted] [DEVICE OR MOUNT-POINT]
- 查看空间使用率 btrfs filesystem df
- 挂载并启用透明压缩：mount -o compress=(lzo|zlib) /DEVICE /MOUNT-POINT

```
[root@localhost ~]# mkfs.btrfs -L mydata /dev/sdb /dev/sdc
btrfs-progs v4.9.1
See http://btrfs.wiki.kernel.org for more information.

Label: mydata
UUID: 847358bd-358a-4efc-a1e2-2e36a6f207ae
Node size: 16384
Sector size: 4096
Filesystem size: 16.00GiB
Block group profiles:
  Data: RAID0 1.60GiB
  Metadata: RAID1 1.00GiB
  System: RAID1 8.00MiB
SSD detected: no
Incompat features: extref, skinny-metadata
Number of devices: 2
Devices:
   ID SIZE PATH
    1 8.00GiB /dev/sdb
    2 8.00GiB /dev/sdc

[root@localhost ~]# btrfs filesystem show /dev/sdb
Label: 'mydata' uuid: 847358bd-358a-4efc-a1e2-2e36a6f207ae
        Total devices 2 FS bytes used 112.00KiB
        devid 1 size 8.00GiB used 1.81GiB path /dev/sdb
        devid 2 size 8.00GiB used 1.81GiB path /dev/sdc
[root@localhost ~]# mount -o compress=lzo /dev/sdb /mydata
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 16G 17M 14G 1% /mydata
[root@localhost ~]# btrfs filesystem df /mydata
Data, RAID0: total=1.60GiB, used=640.00KiB
System, RAID1: total=8.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B
```

### 联机调整大小

- btrfs filesystem resize [+-][KMG] /MOUNT_POINT
- 最大可以为max

```
[root@localhost ~]# btrfs filesystem resize -5G /mydata/
Resize '/mydata/' of '-5G'
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 11G 17M 4.0G 1% /mydata
[root@localhost ~]# btrfs filesystem resize +3G /mydata/
Resize '/mydata/' of '+3G'
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 14G 17M 10G 1% /mydata
[root@localhost ~]# btrfs filesystem resize max /mydata/
Resize '/mydata/' of 'max'
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 16G 17M 14G 1% /mydata
```

### 联机添加物理卷

- btrfs device add /DEVICE /MOUNT_POINT

```
[root@localhost ~]# btrfs device add /dev/sdd /mydata
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 24G 17M 21G 1% /mydata
```

### 均衡操作

- btrfs balance start /MOUNT_POINT 开始为start，暂停为pause，继续为resume，状态为status

```
[root@localhost ~]# btrfs balance start /mydata
WARNING:

        Full balance without filters requested. This operation is very
        intense and takes potentially very long. It is recommended to
        use the balance filters to narrow down the balanced data.
        Use 'btrfs balance start --full-balance' option to skip this
        warning. The operation will start in 10 seconds.
        Use Ctrl-C to stop it.
10 9 8 7 6 5 4 3 2 1
Starting balance without any filters.
Done, had to relocate 3 out of 3 chunks
```

### 联机删除物理卷

- btrfs device delete /DEVICE /MOUNT_POINT

```
[root@localhost ~]# btrfs device delete /dev/sdd /mydata
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 16G 18M 16G 1% /mydata
```

### 修改文件系统组织方式

- btrfs balance start -mconvert=<type> -dconvert=<type> /MOUNT_POINT

```
[root@localhost ~]# btrfs device add /dev/sdd /mydata
[root@localhost ~]# btrfs balance start -mconvert=raid5 -dconvert=raid5 /mydata 
Done, had to relocate 3 out of 3 chunks
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 24G 17M 23G 1% /mydata
```

### 子卷管理

#### 查看子卷

- btrfs subvolume list /MOUNT_POINT

#### 创建子卷

- btrfs subvolume create /mydata/logs
- btrfs subvolume create /mydata/cache

```
[root@localhost ~]# btrfs subvolume create /mydata/logs
Create subvolume '/mydata/logs'
[root@localhost ~]# btrfs subvolume create /mydata/cache
Create subvolume '/mydata/cache'
[root@localhost ~]# tree /mydata/
/mydata/
├── cache
└── logs

2 directories, 0 files
[root@localhost ~]# btrfs subvolume list /mydata/
ID 264 gen 63 top level 5 path logs
ID 265 gen 63 top level 5 path cache
```

#### 只挂载子卷

- 卸载父卷
- mount -o subvol=logs(subvolid=ID) /DEVICE /MOUNT_POINT
- 查看子卷详细信息：btrfs subvolume show /MOUNT_POINT

```
[root@localhost ~]# umount /mydata/
[root@localhost ~]# mount -o subvol=logs /dev/sdb /mnt
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 24G 17M 23G 1% /mnt
[root@localhost ~]# btrfs subvolume show /mnt
/mnt
        Name: logs
        UUID: 552560d4-282d-3049-895c-78f5495fe92f
        Parent UUID: -
        Received UUID: -
        Creation time: 2018-06-06 17:53:22 +0800
        Subvolume ID: 264
        Generation: 63
        Gen at creation: 62
        Parent ID: 5
        Top level ID: 5
        Flags: -
        Snapshot(s):
```

#### 删除子卷

- btrfs subvolume delete /MOUNT_POINT

```
[root@localhost ~]# umount /mnt/
[root@localhost ~]# mount -o compress=lzo /dev/sdb /mydata/
[root@localhost ~]# btrfs subvolume delete /mydata/cache
Delete subvolume (no-commit): '/mydata/cache'
[root@localhost ~]# ls /mydata/
logs
```

#### 创建子卷快照

- btrfs subvolume snapshot /SUBVOLUME_PATH /SNAPSHOT_PATH

```
[root@localhost logs]# cp /etc/fstab /mydata/logs/
[root@localhost logs]# ls
fstab
[root@localhost logs]# cd ..
[root@localhost mydata]# ls
logs
[root@localhost mydata]# btrfs subvolume snapshot /mydata/logs/ /mydata/logs_snapshot_20180606_1804
Create a snapshot of '/mydata/logs/' in '/mydata/logs_snapshot_20180606_1804'
[root@localhost mydata]# cd /mydata/logs_snapshot_20180606_1804/
[root@localhost logs_snapshot_20180606_1804]# ls
fstab
[root@localhost logs_snapshot_20180606_1804]# cd ..
[root@localhost mydata]# ls
logs logs_snapshot_20180606_1804
[root@localhost mydata]# cd logs
[root@localhost logs]# ls
fstab
[root@localhost logs]# echo "hello" >> /mydata/logs/fstab
[root@localhost logs]# tail -1 /mydata/logs
logs/ logs_snapshot_20180606_1804/
[root@localhost logs]# tail -1 /mydata/logs_snapshot_20180606_1804/fstab
UUID=200259c9-e2bb-4768-a136-4e6f2d287686 swap swap defaults 0 0
[root@localhost logs]# btrfs subvolume delete /mydata/logs_snapshot_20180606_1804/
Delete subvolume (no-commit): '/mydata/logs_snapshot_20180606_1804'
[root@localhost logs]# ls /mydata/
logs
```

#### 文件快照

- cp --reflink a.txt a.txt_snap
- bug:https://bugs.centos.org/view.php?id=14228

#### ext3/4 转为 btrfs

1. 卸载ext3/4
2. 强制检测：fsck -f /DEVICE
3. 转换：btrfs-convert  /DEVICE
4. 回滚：btrfs-convert -r /DEVICE

```
[root@localhost ~]# mkfs.ext4 /dev/sdd1
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
524288 inodes, 2096896 blocks
104844 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=2147483648
64 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632

Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done
[root@localhost ~]# mount /dev/sdd1 /media/
[root@localhost ~]# cd /media/
[root@localhost media]# ls
lost+found
[root@localhost media]# touch abc
[root@localhost media]# echo "hello" > abc
[root@localhost media]# cd
[root@localhost ~]# umount /media/
[root@localhost ~]# fsck -f /dev/sdd1
fsck from util-linux 2.23.2
e2fsck 1.42.9 (28-Dec-2013)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdd1: 12/524288 files (0.0% non-contiguous), 74896/2096896 blocks
[root@localhost ~]# btrfs-convert /dev/sdd1
create btrfs filesystem:
        blocksize: 4096
        nodesize: 16384
        features: extref, skinny-metadata (default)
creating ext2 image file
creating btrfs metadatacopy inodes [o] [ 0/ 12]
conversion complete
[root@localhost ~]# mount /dev/sdd1 /media/
[root@localhost ~]# df -h
Filesystem Size Used Avail Use% Mounted on
/dev/sda3 119G 1.2G 118G 1% /
devtmpfs 235M 0 235M 0% /dev
tmpfs 245M 0 245M 0% /dev/shm
tmpfs 245M 4.4M 240M 2% /run
tmpfs 245M 0 245M 0% /sys/fs/cgroup
/dev/sda1 197M 97M 101M 50% /boot
tmpfs 49M 0 49M 0% /run/user/0
/dev/sdb 16G 17M 15G 1% /mnt
/dev/sdd1 8.0G 310M 7.7G 4% /media
[root@localhost ~]# blkid /dev/sdd1
/dev/sdd1: UUID="d7b543e7-376b-44ff-99bc-d67fd9ca8528" UUID_SUB="1c80039f-2f30-4466-9735-3077400b99c6" TYPE="btrfs"
[root@localhost ~]# ls /media/
abc ext2_saved/ lost+found/
[root@localhost ~]# ls /media/abc
/media/abc
[root@localhost ~]# cat /media/abc
hello
[root@localhost ~]# btrfs-convert -r /dev/sdd1
ERROR: /dev/sdd1 is mounted
[root@localhost ~]# umount /dev/sdd1
[root@localhost ~]# btrfs-convert -r /dev/sdd1
rollback complete
[root@localhost ~]# blkid /dev/sdd1
/dev/sdd1: UUID="b506bc50-4158-40f1-8d6d-8d1d33620090" TYPE="ext4"
[root@localhost ~]# mount /dev/sdd1 /media/
[root@localhost ~]# cat /media/abc
hello
[root@localhost ~]# ls /media/
abc lost+found
```

### 文件系统选型

- 大量小文件：resierfs
- 数据库：xfs
- 一般：ext4
- centos5 ext3
- centos6 ext4
- centos7 xfs
