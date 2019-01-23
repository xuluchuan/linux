# linux基础入门

### linux时间线

- System V 与 BSD在80年代版权纠纷
- 1990 BSD移植到X86的386计划中止
- 1991 芬兰linus发明linux
- 1994 Linux1.0发布，可用于生产环境

### 操作系统

- os = kernel + application

### 操作系统功能

- 驱动硬件
- 进程管理
- 安全防护
- 网络功能
- 内存管理
- 文件系统
- 将硬件规格抽象为系统调用并提供接口，包括交互接口和调用接口

### 接口包括

- 交互接口：GUI图形用户界面（GNOME KDE） CLI命令行界面 bash
- 调用接口：API应用编程接口，系统调用接口和库调用接口

### 操作系统架构图

```
用户
|
应用程序
|
交互接口 GUI/CLI
|
库调用（glibc）
|
系统调用 (system call)
|
内核
|
硬件
```

- android底层是linux kernel arm架构
- GNU/LINUX 是操作系统源码（包括gcc，glibc，vi，shell，kernel），编译成二进制可安装的操作系统是发行版

### linux发行版分支

- 主流三个
    + Debian→**ubuntu**
    + Slackware→**openSUSE**
    + Redhat→**centos**（rhel源码去掉商标后的再编译版本）
- 其他两个
    + Gentoo
    + Arch

### 版本号

- major.minor.release
- 主版本号.次版本号.bug修复号
- 软件不需要安装最新版本
- Centos 7.5