# 压缩工具及bash脚本编程

### 压缩/解压缩

- 目的：用cpu时钟的计算能力换磁盘空间
- 常见格式：
    1. compress/uncompress .z
    2. gzip/gunzip/zcat .gz
    3. bzip2/bunzip2/bzcat .bz2
    4. xz/unxz/xzcat .xz
    5. zip/unzip .zip

#### gzip

- gzip FILE 删除源文件，生成压缩文件 FILE.gz
- gunzip FILE.gz 删除压缩文件，生成源文件 FILE
- zcat FILE.gz 查看文件
- -d：解压缩
- -#：指定压缩比，默认为6,1-9，数字越大，压缩比越大
- gzip -c FILE > FILE.gz：不删除源文件，而是将压缩结果输出至标准输出，可以用文件接收

#### bzip2

- bzip2 FILE 删除源文件，生成压缩文件 FILE.bz2
- bunzip2 FILE.bz2 删除压缩文件，生成源文件 FILE
- bzcat FILE.bz2 查看文件
- -d：解压缩
- -#：指定压缩比，默认为6,1-9，数字越大，压缩比越大
- -k：不删除源文件

#### xz

- xz FILE 删除源文件，生成压缩文件 FILE.xz
- unxz FILE.xz 删除压缩文件，生成源文件 FILE
- xzcat FILE.xz 查看文件
- -d：解压缩
- -#：指定压缩比，默认为6,1-9，数字越大，压缩比越大
- -k：不删除源文件
- gzip，bzip2，xz都只能压缩文件，不能压缩目录

### 归档

- 归档时进入要打包文件的上一级目录，使用./

#### tar

##### 创建归档

- tar cf /PATH/TO/SOMEFILE.tar FILE...

##### 展开归档

- tar xf /PATH/FROM/SOMEFILE.tar 默认解压到当前目录，后接-C /PATH/TO/SOMEWHERE展开至指定目录

##### 查看归档文件列表

- tar tf /PATH/FROM/SOMEFILE.tar

##### 归档后完成压缩

- 调用gzip ：tar zcf
- 调用bzip2：tar jcf
- 调用xz：tar Jcf
- 解压缩：tar xf
- 需要安装bzip2 yum -y install bzip2

```
[root@localhost ~]# cd /
[root@localhost /]# yum -y install bzip2
[root@localhost /]# ls -lh /root/
total 25M
-rw-------. 1 root root 1.2K May 9 23:05 anaconda-ks.cfg
-rw-r--r-- 1 root root 8.3M Jun 8 14:36 etc.tar.bz2
-rw-r--r-- 1 root root 9.4M Jun 8 14:36 etc.tar.gz
-rw-r--r-- 1 root root 6.6M Jun 8 14:37 etc.tar.xz
drwxr-xr-x 2 root root 191 Jun 4 11:25 scripts
[root@localhost /]# tar jcf /root/etc.tar.bz2 ./etc/
[root@localhost /]# tar zcf /root/etc.tar.gz ./etc/
[root@localhost /]# rm -f /root/etc.tar.xz
[root@localhost /]# tar Jcf /root/etc.tar.xz ./etc/
[root@localhost /]# tar xf /root/etc.tar.xz -C /tmp/
[root@localhost /]# ls /tmp/
etc
```

#### zip

- 既能归档，又能压缩
- 压缩：zip FILE.zip FILE
- 解压缩：unzip FILE.zip
- 目录需要 -r
- 需要安装zip yum -y install zip unzip

```
[root@localhost tmp]# yum -y install zip unzip
[root@localhost tmp]# zip -r etc.zip ./etc/
[root@localhost tmp]# ls
etc etc.zip
[root@localhost tmp]# unzip etc.zip
Archive: etc.zip
   creating: etc/
[root@localhost tmp]# ls
etc etc.zip
```

### 用户交互read

- 用户键盘输入，完成变量赋值
- 变量之间用空格隔开
- -p：提示词
- -t：超时时间
- 避免无输入：[ -z "$name" ] && name="NAME"
- 交互输入用户名，密码，添加用户

```
[root@localhost scripts]# cat addUser.sh
#!/bin/bash
# description: 输入用户名，密码，添加用户
# author: xuluchuan
# version: 1.0
# date: 20180608
read -t 10 -p "请输入用户名：" username
[ -z "$username" ] && echo "必须输入用户名" && exit 1
read -t 10 -p "请输入密码[password]:" password
[ -z "$password" ] && password="password"
if id $username &> /dev/null; then
    echo "用户名已经存在"
    exit 2
else
    useradd $username && \
    echo "$password" | passwd $username --stdin &> /dev/null && \
    echo "用户名添加成功"
fi
[root@localhost scripts]# ./addUser.sh
请输入用户名：hadoop
请输入密码[password]:
用户名添加成功
[root@localhost scripts]# su - hadoop
[hadoop@localhost ~]$ exit
```

### 语法检查bash

- bash -n 语法错误检查
- bash -x 调试执行

```
[root@localhost scripts]# bash -n addUser.sh
[root@localhost scripts]# bash -x addUser.sh
+ read -t 10 -p $'\350\257\267\350\276\223\345\205\245\347\224\250\346\210\267\345\220\215\357\274\232' username
请输入用户名：hadoop
+ '[' -z hadoop ']'
+ read -t 10 -p '请输入密码[password]:' password
请输入密码[password]:
+ '[' -z '' ']'
+ password=password
+ id hadoop
+ useradd hadoop
+ echo password
+ passwd hadoop --stdin
+ echo $'\347\224\250\346\210\267\345\220\215\346\267\273\345\212\240\346\210\220\345\212\237'
用户名添加成功
```
