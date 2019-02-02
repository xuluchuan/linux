# Linux根文件系统层级标准FHS

### 静态编译与动态编译

- 静态编译把依赖库复制一份到程序中进行编译，动态编译没有复制，需要依赖库时再调用，节约内存。

### 挂载

- 将分区关联到根文件系统上

### 启动

- 主板bios芯片找BootLoader，然后再找root根文件系统

### FHS

- filesystem hierarchy standard 文件系统层级结构标准

### /bin

- 供所有用户使用的基本用户二进制命令文件

### /sbin

- 系统管理的二进制文件

### /boot

- 引导加载器需要使用的静态文件，包括kernel init grub等

### /dev

- 设备文件或特殊文件
- -：常规文件 regular file
- d：目录文件directory（路径映射）
- b：块设备 block device 以block为单位随机访问，如硬盘 内存
- c：字符设备 character device 以字符为单位线性访问，如显示器 键盘
- l：符号链接文件 symbolic link 软链接 
- s：套接字文件 socket 两个进程间通信
- p：命名管道文件 pipe 

### /etc

- 按程序组织的配置文件

### /home

- 普通用户家目录，/home/USERNAME的形式

### /root

- 管理员的家目录

### /lib

- 基本共享库和内核模块
- libc.so.*动态链接C库
- ld* 运行时加载器

### /lib64

- 64为系统特有的基本共享库

### /media

- 便携性设备的挂载点

### /mnt

- 临时文件系统的挂载点

### /srv

- 服务数据

### /tmp

- 临时文件，所有用户都有写权限

### /usr全局共享只读资源，二级层级目录

- /usr/bin
- /usr/sbin(命令)
- /usr/lib
- /usr/lib64(库) 
- /usr/include(头文件)
- /usr/share(共享数据man doc)
- /usr/src(源码) 
- /usr/X11R6 xwindow的资源

### /usr/local 三级本地层级目录

- /usr/local/bin /usr/local/sbin /usr/local/lib /usr/local/lib64
- /usr/local/src /usr/local/etc /usr/local/share /usr/local/include

### /opt

- 第三方非关键程序的安装位置

### /var 可变的数据文件

- /var/cache 缓存文件
- /var/lib 状态信息
- /var/lock 锁文件
- /var/log 日志文件
- /var/mail 邮件文件
- /var/opt opt的可变数据
- /var/run 运行时的变化数据
- /var/spool 队列可变数据
- /var/spool/cron 任务编排队列
- /var/tmp重启后不会丢失的临时文件
- /var/cron 定时任务

### /proc 

- 显示内核信息和处理信息的虚拟文件系统

### /sys

- 重要管理设备的虚拟文件系统
