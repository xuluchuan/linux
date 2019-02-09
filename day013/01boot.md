# centos启动流程

- 启动分区：/boot 只能采用基本文件系统
- rootfs：/ FHS结构 
- 单内核：所有功能集成在同一个程序 linux
- 微内核：每种功能使用一个单独的子系统实现 windows

### linux内核特点

- 支持模块化
- 支持模块运行时动态装载和卸载模块
- .ko为内核模块文件
- cat /etc/issue 或 uname -r查看内核
- centos6为2.32，centos7位3.10
- 内核三种文件
    + 内核核心文件：/boot/vmlinuz-VERSION-RELEASE
    + ramdisk：5 /boot/initrd-VERSION-RELEASE.img 6为initramfs
    + 模块文件：/lib/modules/VERSION-RELEASE

### 第一步：加电自检

- 通过读取ROM的cmos和bios进行加电自检，检查系统硬件是否正常工作

### 第二步：系统引导

- 按照BIOS中的boot sequence 顺序查找可引导设备，第一个可以使用的进行引导
- 引导使用BootLoader 引导加载器
- linux的BootLoader要借助grub实现
- 5.6是0.x，7是grub2
- grub的功能是提供菜单，选择系统的不同内核，将选定的内核装载到ramdisk，解压后展开，将控制权给内核

### 第三步：加载内核

- 内核需要自身初始化：
    + 1.探测可识别的所有硬件设备
    + 2.加载硬件的驱动程序（可能会借助ramdisk驱动）
    + 3.以只读方式挂载根文件系统rootfs
    + 4.运行用户空间的第一个专用程序：/sbin/init

### 第四步：系统初始化

- 1.根据/etc/inittab设置运行级别
    + 运行级别有：0关机，1单用户模式，2多用户模式，不启动nfs，3多用户模式，4预留，5多用户模式，图形界面，6重启，reboot
    + 默认3和5级别
    + 级别切换：init #
    + 级别查看：who -r，runlevel
    + 配置文件格式：id（标识）:runlevels（哪些级别）:action（在什么条件下）:process（具体任务）
    + id:3:initdefault:
- 2.根据/etc/rc.d/rc.sysinit初始化脚本初始化（5 si::sysinit:/etc/init.d/rc.sysinit）
    - 1.设置主机名
    - 2.设置欢迎信息
    - 3.激活udev和selinux
    - 4.挂载/etc/fstab文件系统
    - 5.检测根文件系统，以读写方式挂载
    - 6.设置硬件时钟
    - 7.根据/etc/sysctl.conf设置内核参数
    - 8.激活lvm和软raid
    - 9.激活swap
    - 10.加载额外设备的驱动程序
    - 11.清理操作
- 3.启动或关闭对应级别的服务脚本（5：lo:0:wait:/etc/rc.d/rc 3）
    + /etc/rc.d/rc3.d（/etc/rc.d/init.d/的软链接）是3级别的脚本,K开头关闭，S开头开启
    + 可以使用/etc/init.d/* {start|stop|restart|status} 管理服务
    + 可以使用service script {start|stop|restart|status} 管理服务
    + chkconfig 管理 各个级别K,S的软链接   
    + chkconfig --add 服务名添加脚本
    + chkconfig [--level LEVELS] on/off/reset 设置服务启动级别
    + chkconfig --del 服务 删除
    + chkconfig --list [name] 查看清单
    + /etc/rc.d/rc.local 软链接 /etc/rc.local是正常级别的最后启动的 
+ 4.登录终端(5 tty1:2345:respawn:/usr/sbin/mingtty tty1)
+ 5.登录图形终端
+ 注：centos6采用upstart加载/etc/init/*.conf
    + centos7采用systemd加载/usr/lib/systemd/* /etc/systemd/*
    + centos7服务使用systemctl {start|stop} name.service来控制服务

```
[root@centos6-mould init.d]# cat testsrv
#!/bin/bash
#
# testsrv Start up the Testsrv server daemon
#
# chkconfig: 2345 70 70
# description: TESTSRV is a testsrv server daemon

# source function library
. /etc/rc.d/init.d/functions

RETVAL=0
prog="testsrv"

start()
{
        echo -n $"Starting $prog: "
        $prog &> /dev/null
        RETVAL=$?
        echo
        return $RETVAL
}

stop()
{
        echo -n $"Stopping $prog: "
        killall $prog &> /dev/null
        RETVAL=$?
        echo
        return $RETVAL
}


restart() {
        stop
        start
}

status() {
        pidof $prog &> /dev/null
        RETVAL=$?
        if [ $RETVAL -eq 0 ]; then
            echo "$prog is running"
        else
            echo "$prog is not running"
        fi
        echo
        return $RETVAL
}

case "$1" in
        start)
                start
                ;;
        stop)
                stop
                ;;
        restart)
                restart
                ;;
        status)
                status
                ;;
        *)
                echo $"Usage: $0 {start|stop|restart|status}"
                RETVAL=2
esac
exit $RETVAL

[root@centos6-mould init.d]# chkconfig --list testsrv
service testsrv supports chkconfig, but is not referenced in any runlevel (run 'chkconfig --add testsrv')
[root@centos6-mould init.d]# chkconfig --add testsrv
[root@centos6-mould init.d]# chkconfig --list testsrv
testsrv 0:off 1:off 2:on 3:on 4:on 5:on 6:off
[root@centos6-mould init.d]# chmod +x testsrv
[root@centos6-mould init.d]# /etc/init.d/testsrv status
testsrv is not running

[root@centos6-mould init.d]# /etc/init.d/testsrv start
Starting testsrv:
[root@centos6-mould init.d]# /etc/init.d/testsrv stop
Stopping testsrv: Terminated
[root@centos6-mould init.d]# /etc/init.d/testsrv restart
Stopping testsrv: Terminated
[root@centos6-mould init.d]# /etc/init.d/testsrv restar
Usage: /etc/init.d/testsrv {start|stop|restart|status}
[root@centos6-mould init.d]# /etc/init.d/testsrv
Usage: /etc/init.d/testsrv {start|stop|restart|status}
```

- post→boot sequence(bios)→boot loader（mbr）→kernel（ramdisk）→rootfs→switchroot→/sbin/init→/etc/inittab,/etc/init/*.conf→设定默认运行级别→系统初始化脚本→关闭或启动对应级别的服务→启动终端

