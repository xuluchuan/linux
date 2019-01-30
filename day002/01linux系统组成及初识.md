# linux系统组成及初识

### cpu架构

- 个人PC ： x86
- 手持移动： arm
- SUN的solaris：ultrasparc
- IBM的AIX：power
- HP的HP-UNIX：alpha
- 可以在x86上交叉编译arm的程序
- linux（elf）和windows（exe）的二进制文件不同，编译后不兼容
- unix-like系统ABI兼容，编译后兼容

### 开源协议

- GPL：修改也要开源
- LGPL：只使用库和接口调用可闭源
- BSD，Apache：修改可闭源

- windows是闭源系统，linux是开源系统
- 双线授权模式：社区版开源，企业版增加功能闭源

### 程序管理

- 程序组成
    + 二进制程序
    + 配置文件
    + 库文件
    + 帮助文件

### 各发行版区别

- 主要是包管理器不同：

|发行版|  包管理器 | 前端|
|-------|------|--------|
|Debian：|dpkg(.deb格式)|apt-get|
|Redhat：| rpm （.rpm格式）| yum|
|Suse：| rpm |zypper|
|Arch：| packman| |
|Gentoo：|自己编译|  |
|kali：|内置渗透工具|  |
|LFS：|Linux From Scratch| 自己编译linux|

### virtualbox安装linux centos7.4

- CentOS的镜像站点：http://mirrors.aliyun.com
- 最小化安装 512M内存，120G硬盘，桥接网络，时区上海，关闭kdump
- 分区：200M boot 1.5倍最大8Gswap 其余根/

### 命令

#### 开启图形化界面

```
[root@localhost ~]# startx
```

#### 查询当前字符编码（en_US.UTF-8）

```
[root@localhost ~]# locale
```

#### 查询可设置字符编码

```
[root@localhost ~]# localectl list-locales
```

#### 设置为中文字符编码，重进终端生效

```
[root@localhost ~]# localectl set-locale LANG=zh_CN.utf8
```
