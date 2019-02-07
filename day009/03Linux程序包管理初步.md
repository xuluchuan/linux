# Linux程序包管理初步

### 应用程序分类

- 库级别虚拟化
    + linux运行windows程序：wine
    + windows运行linux程序：cywin
- 系统级应用程序（性能高，代码量大）
    + c/c++ (httpd vsftpd nginx)
    + go(docker)
- 应用级应用程序（性能低，代码量少）
    + java（hadoop，hbase，elk），运行在jvm上
    + python（OpenStack），运行在pvm上
    + perl，使用perl解释器解释
    + ruby，使用ruby解释器解释
    + php，使用php解释器解释

#### c/c++ 程序格式

- 源代码格式：文本格式的程序代码
- 二进制格式：源代码编译后，分为二进制文件，库文件，配置文件，帮助文件
- 编译开发环境：编译器，头文件，开发库
- 项目构建工具：make

#### java/python 程序格式

- 源代码
- 二进制：源代码编译后，编译成能够运行在虚拟机上运行的格式（字节码）
- 编译开发环境：编译器，开发库
- 项目构建工具：maven

### 程序包管理器

- 将源代码编译成目标二进制文件，并组成一个或有限几个包文件
- 可以进行安装，升级，卸载，查询，校验操作
- debian系（ubuntu）：dpkg，.deb
- redhat系（centos）：rpm，.rpm
- slackware系（suse）：rpm，.rpm
- gentoo：ports

### 格式

#### 源代码格式

- name-version.tar.gz
- version：major.minor.release

#### rpm包格式

- name-version-release.arch.rpm
- release为release.os，rpm包的发行号和操作系统版本
- arch有i386,i586,i686,x64(amd64),ppc,noarch(全部平台)

#### rpm拆包

- rpm分为主包和支包
- 支包为name-function-version-release.arch.rpm
- function有devel，utils，libs等

### 依赖关系

- 前端工具：自动解决依赖关系
- yum：rhel系rpm包管理器的前端工具
- apt-get（apt-cache）：deb系
- zypper：suse系
- dnf：fedora22之后

### 程序包管理器组成

- 程序包的组成清单
    + 文件清单
    + 安装，卸载脚本
- 数据库（/var/lib/rpm）
    1. 程序包名称，版本
    2. 依赖关系
    3. 功能说明
    4. 安装生成文件路径，校验码

### 获取程序包的途径

1. 优先选择系统发行版光盘或镜像站点（如mirrors.163.com）
2. 项目官方站点
3. 第三方组织
    + epel源
    + pkgs.org
    + rpmfind.net
    + rpm.pbone.net
4. 自己制作rpm包
5. 拿到rpm包后要检查rpm包的合法性和完整性

