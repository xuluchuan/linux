# 特殊权限及facl

### 特殊权限

- 特殊权限分为suid sgid sticky

### 安全上下文

1. 进程以某用户身份运行，进程是发起此进程的代理，因此以用户的身份和权限完成所有操作
2. 权限匹配模型
    1. 判断进程的属主是否是被访问资源的属主，如果是，应用属主权限，否则进入2
    2. 判断进程的属主是否是被访问资源的属组，如果是，应用属组权限，否则进入3
    3. 应用other权限

### SUID    

- 默认情况下，用户发起的进程，进程的属主是其发起者，因为以其发起者运行
- SUID功用：如果用户运行某程序，此程序为SUID权限，此程序运行为进程时，其属主不是发起者，而是文件的属主。
- SUID权限有风险，不建议使用
- 设置方式：chmod u+s FILE 或 chmod u-s FILE
- ls -l 查看权限，属主的x位，若原来有x，则为s，没有x，则为S

```
[root@localhost ~]# ls -l `which passwd`
-rwsr-xr-x. 1 root root 30768 Nov 24 2015 /usr/bin/passwd
```


### SGID

- SGID功用：如果目录的属组有写权限，加入SGID后，所有属组成员新建的文件的属组为此目录的属组
- 设置方式：chmod g+s DIR 或 chmod g-s DIR
- ls -l 查看权限，属组的x位，若原来有x，则为s，没有x，则为S

```
[root@localhost ~]# useradd linux
[root@localhost ~]# useradd centos
[root@localhost ~]# useradd fedora
[root@localhost ~]# mkdir /develop
[root@localhost ~]# chmod 775 /develop
[root@localhost ~]# chown linux:linux /develop/
[root@localhost ~]# chmod g+s /develop/
[root@localhost ~]# ls -ld /develop
drwxrwsr-x 2 linux linux 4096 May 28 16:57 /develop
[root@localhost ~]# usermod -a -G linux centos
[root@localhost ~]# usermod -a -G linux fedora
[root@localhost ~]# su - centos
[centos@localhost ~]$ cd /develop/
[centos@localhost develop]$ ls
[centos@localhost develop]$ touch abc
[centos@localhost develop]$ ll
total 0
-rw-rw-r-- 1 centos linux 0 May 28 16:59 abc
[centos@localhost develop]$ exit
logout
[root@localhost ~]# su - fedora
[fedora@localhost ~]$ cd /develop/
[fedora@localhost develop]$ ll
total 0
-rw-rw-r-- 1 centos linux 0 May 28 16:59 abc
[fedora@localhost develop]$ echo "hello" > abc
[fedora@localhost develop]$ cat abc
hello
[fedora@localhost develop]$ touch 123
[fedora@localhost develop]$ ll
total 4
-rw-rw-r-- 1 fedora linux 0 May 28 17:00 123
-rw-rw-r-- 1 centos linux 6 May 28 17:00 abc
```


### sticky

- stickey 功用：如果属组或全局有写权限，组内或系统上的所有用户在此目录中都能创建新文件或删除文件，如果设置为sticky权限，则每个用户都能创建新文件，但只能删除自己为属主的文件
- 例如/tmp /var/tmp 
- 设置方式：chmod o+t DIR 或 chmod o-t DIR
- ls -l 查看权限，其他的x位，若原来有x，则为t，没有x，则为T

```
[root@localhost ~]# chmod o+t /develop/
[root@localhost ~]# ll /develop/ -d
drwxrwsr-t 2 linux linux 4096 May 28 17:00 /develop/
[root@localhost ~]# su - centos
[centos@localhost ~]$ ll
total 0
[centos@localhost ~]$ cd /develop/
[centos@localhost develop]$ ll
total 4
-rw-rw-r-- 1 fedora linux 0 May 28 17:00 123
-rw-rw-r-- 1 centos linux 6 May 28 17:00 abc
[centos@localhost develop]$ rm -f 123
rm: cannot remove `123': Operation not permitted
[centos@localhost develop]$ rm -f abc
[centos@localhost develop]$ ll
total 0
-rw-rw-r-- 1 fedora linux 0 May 28 17:00 123
[centos@localhost develop]$ echo "123" > 123
[centos@localhost develop]$ cat 123
123
```

### 八进制设置特殊权限位

- suid 4 sgid 2 stickey 1 0-7八进制
- 例如 chmod 1777 /tmp

### facl :file access control lists 文件访问控制列表

- 文件额外赋权机制
- 在原有ugo之外，让普通用户能控制赋权给另外的用户或组的机制
- 查看facl权限：getfacl FILE
- 设置facl用户权限：setfacl -m u:USERNAME:MODE FILE 
- 设置facl组权限：setfacl -m g:GROUPNAME:MODE FILE
- 撤销facl用户权限：setfacl -x u:USERNAME FILE
- 撤销facl组权限：setfacl -x g:GROUPNAME FILE
- ll 查看到文件权限位最后多了一个+
- 安全上下文改变：属主→facl user→属组→facl group→其他用户

```
[root@localhost ~]# useradd redhat
[root@localhost ~]# su - fedora
[fedora@localhost ~]$ cd /develop/
[fedora@localhost develop]$ ls
123
[fedora@localhost develop]$ setfacl -m u:redhat:rw- 123
[fedora@localhost develop]$ ll
total 4
-rw-rw-r--+ 1 fedora linux 4 May 28 17:21 123
[fedora@localhost develop]$ getfacl 123
# file: 123
# owner: fedora
# group: linux
user::rw-
user:redhat:rw-
group::rw-
mask::rw-
other::r--
[fedora@localhost develop]$ exit
logout
[root@localhost ~]# su - redhat
[redhat@localhost ~]$ cd /develop/
[redhat@localhost develop]$ ll
total 4
-rw-rw-r--+ 1 fedora linux 4 May 28 17:21 123
[redhat@localhost develop]$ echo abc > 123
[redhat@localhost develop]$ cat 123
abc
```
