# grub（boot loader）

- centos6是grub legacy
- stage1 mbr
- stage1.5 mbr之后的扇区，让1识别2的文件系统
- stage2 磁盘分区/boot/grub

### 功能

- 提供菜单，并提供交互式接口（编辑模式或命令模式）
- 选择内核（传递参数或隐藏菜单）
- 保护系统（编辑菜单可以认证，启动内核或操作系统可以认证）

### 命令行接口

- help
- help COMMAND
- root (hd0,0)设定根分区为第一块磁盘的第一个分区
- find (hd0,0)/PATH 查找文件
- kernel /PATH init=/sbin/init selinux=0 ro root=/dev/DEVICE 设定内核文件
- initrd /PATH    设定ramdisk
- boot 启动

### 配置文件

- /etc/grub.conf 是/boot/grub/grub.conf的软链接
- 配置项：
    + hiddenmenu：隐藏菜单
    + timeout：超时时间
    + default：默认启动菜单项，从0开始
    + splashing：图片
    + title：标题
    + password --md5 STRING：编辑内核时要按p输入密码（使用grub-md5-crypt生成）

### 进入单用户模式（忘记root密码，重置root密码）

- 1.在title上按e编辑
- 2.在kernel上附加1，s，S或single
- 3.在kernel上按b启动

### 安装grub

- 1.grub-install --root-directory=ROOT /dev/DISK
- 2.或进入grub命令行
    + 1.root (hd#,#)
    + 2.setup (hd#)

### 其他

- 关机或重启前需要sync把操作写入硬盘
- 可以给新添加硬盘安装grub
- ldd查看库文件，可以将给新系统装bash
- chroot可以改变根文件系统
- 加载光盘有救援模式
