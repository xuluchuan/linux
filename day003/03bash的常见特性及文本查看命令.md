# bash的常见特性及文本查看命令

### bash shell基础特性之二 命令补全

- shell在接受到用户执行的命令请求，分析完成后，最左侧的字符串会被当做命令
- 命令处理机制：先查找内部命令，再根据PATH自左到右查找外部命令
- 给定打头字符串按tab：有唯一标识，则直接补全，不能唯一标识，则再击tab，给出列表
- 路径补全：给定起始路径和对应路径下的打头字符串按tab，逐一匹配起始路径下的每个文件，有唯一标识，则直接补全，不能唯一标识，则再击tab，给出列表
- 补全机制可以避免出错，敲几次tab没反应，就出错了

### 目录管理命令

#### mkdir

- make directories 创建目录
- 基名前的路径必须存在
- 如果不存在，则使用-p选项，创建多级目录
- -v显示详细信息

```
[root@localhost tmp]# mkdir /tmp/a
[root@localhost tmp]# mkdir -p /tmp/a/b/c
[root@localhost tmp]# mkdir -pv /tmp/a/b/c/d/e
mkdir: created directory ‘/tmp/a/b/c/d’
mkdir: created directory ‘/tmp/a/b/c/d/e’
```

- -m设定权限

#### rmdir

- remove directories 删除空目录
- -p删除多级

```
[root@localhost tmp]# rmdir a/b/c/d/e/
[root@localhost tmp]# rmdir -p a/b/c/d/
```

### bash shell基础特性之三 命令行展开功能

- ~自动展开为用户的家目录
- {}分组以,分隔的路径列表，将其展开为多个路径

```
[root@localhost tmp]# mkdir -pv /tmp/x/{y1/{a,b},y2}
mkdir: created directory ‘/tmp/x’
mkdir: created directory ‘/tmp/x/y1’
mkdir: created directory ‘/tmp/x/y1/a’
mkdir: created directory ‘/tmp/x/y1/b’
mkdir: created directory ‘/tmp/x/y2’
[root@localhost tmp]# tree /tmp/x
/tmp/x
├── y1
│ ├── a
│ └── b
└── y2
[root@localhost tmp]# mkdir -v {a,b}_{c,d}
mkdir: created directory ‘a_c’
mkdir: created directory ‘a_d’
mkdir: created directory ‘b_c’
mkdir: created directory ‘b_d’
```

### tree命令

- 树状显示目录层级结构
- -L制定显示的层级

#### 7

```
[root@localhost tmp]# tree -L 1 /
/
├── bin -> usr/bin
├── boot
├── dev
├── etc
├── home
├── lib -> usr/lib
├── lib64 -> usr/lib64
├── media
├── mnt
├── opt
├── proc
├── root
├── run
├── sbin -> usr/sbin
├── srv
├── sys
├── tmp
├── usr
└── var
19 directories, 0 files
```

#### 6

```
[root@localhost ~]# tree -L 1 /
/
├── bin
├── boot
├── dev
├── etc
├── home
├── lib
├── lib64
├── lost+found
├── media
├── mnt
├── opt
├── proc
├── root
├── sbin
├── selinux
├── srv
├── sys
├── tmp
├── usr
└── var
20 directories, 0 files
```

### bash shell基础特性之四 命令的执行状态结果

- bash通过状态返回值输出此结果：成功为0，失败为1-255
- 命令执行完成后，状态返回值保存于特殊变量$?中，仅保存最近一条命令的
- 命令如果正常执行，会有命令执行结果返回值
- 使用$()或``可以引用命令的执行结果

```
[root@localhost tmp]# mkdir $(date +%F-%H-%M-%S)
[root@localhost tmp]# echo $?
0
[root@localhost tmp]# ls
2018-05-18-09-12-41 2018-05-18-09-12-45 ks-script-6ZKL2e yum.log
[root@localhost tmp]# mkdir `date +%F-%H-%M-%S`
[root@localhost tmp]# ls
2018-05-18-09-12-41 2018-05-18-09-13-03 yum.log
2018-05-18-09-12-45 ks-script-6ZKL2e
```

### bash shell基础特性之五 引用

- 强引用 ''
- 弱引用 ""
- 命令执行结果引用 $() 或 ``

### bash shell基础特性之六 快捷键

- ctrl+A 光标移动到命令行首部
- ctrl+E 光标移动到命令行尾部
- ctrl+U 剪切行首至光标所在处的所有字符
- ctrl+K 剪切光标所在处至行尾的所有字符
- ctrl+Y 粘贴
- ctrl+L 等于clear，清屏
- ctrl+C 中止命令运行
- ctrl+D 退出终端
- ctrl+R 搜索命令历史

### 文本查看命令cat tac head tail more less

#### more，less分屏查看

- more有百分比显示，但翻到尾部会退出，less按q退出
```
[root@localhost ~]# less /etc/rc.d/init.d/functions
[root@localhost ~]# more /etc/rc.d/init.d/functions
```

#### head

- 默认显示前10行
- 显示前#行 head -# 

```
[root@localhost ~]# head -20 /etc/init.d/functions
```

#### tail 

- 默认显示后10行
- 显示后#行 tail -#
- tail -f 显示文件末尾不退出，追踪新行并立即显示 follow

```
[root@localhost tmp]# tail -20f /etc/init.d/functions
```

#### stat

- 查看文件元数据
- 后面三项为时间戳状态
- atime access 访问时间，读取
- mtime modify 更改时间，数据改变
- ctime change 改动时间，元数据改变

```
[root@localhost ~]# stat /etc/yum.conf
  File: `/etc/yum.conf'
  Size: 969 Blocks: 8 IO Block: 4096 regular file
Device: 803h/2051d Inode: 2097417 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2018-05-17 15:11:51.401000000 +0800
Modify: 2017-03-22 13:32:26.000000000 +0800
Change: 2018-05-10 08:56:47.361999914 +0800
```

#### touch

- 手动修改文件的时间戳，若文件不存在则创建空文件
- touch -c 即使文件不存在也不创建空文件
- touch -a 修改atime
- touch -m 修改mtime
- touch -t 指定时间戳 年月日时分.秒

```
[root@localhost ~]# touch a.txt 
[root@localhost ~]# stat a.txt
  File: `a.txt'
  Size: 8 Blocks: 8 IO Block: 4096 regular file
Device: 803h/2051d Inode: 1835020 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2018-05-18 01:38:47.596000524 +0800
Modify: 2018-05-18 01:38:47.596000524 +0800
Change: 2018-05-18 01:38:47.596000524 +0800
[root@localhost ~]# touch -c b.txt
[root@localhost ~]# ls
anaconda-ks.cfg a.txt install.log install.log.syslog
[root@localhost ~]# touch -a a.txt
[root@localhost ~]# stat a.txt
  File: `a.txt'
  Size: 8 Blocks: 8 IO Block: 4096 regular file
Device: 803h/2051d Inode: 1835020 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2018-05-18 01:39:15.558003105 +0800
Modify: 2018-05-18 01:38:47.596000524 +0800
Change: 2018-05-18 01:39:15.558003105 +0800
[root@localhost ~]# touch -m a.txt
[root@localhost ~]# stat a.txt
  File: `a.txt'
  Size: 8 Blocks: 8 IO Block: 4096 regular file
Device: 803h/2051d Inode: 1835020 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2018-05-18 01:39:15.558003105 +0800
Modify: 2018-05-18 01:39:45.579010844 +0800
Change: 2018-05-18 01:39:45.579010844 +0800
[root@localhost ~]# touch -t 201805180011.32 a.txt
[root@localhost ~]# stat a.txt
  File: `a.txt'
  Size: 8 Blocks: 8 IO Block: 4096 regular file
Device: 803h/2051d Inode: 1835020 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2018-05-18 00:11:32.000000000 +0800
Modify: 2018-05-18 00:11:32.000000000 +0800
Change: 2018-05-18 01:40:28.162003780 +0800
```