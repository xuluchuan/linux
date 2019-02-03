# Linux用户和组的基础概念

### 3A原则

- authentication 认证
- authorization 授权
- audition 审计

### 用户类别

#### 管理员

- 管理员用户名：root
- 管理员标识：UID为0

#### 普通用户

- 普通用户的UID为1到60000

#### 普通用户中的系统用户

- 系统用户的UID为1-999（7），1-499（6）

#### 普通用户中的登录用户

- 登录用户的UID为1000-60000（7），500-60000（6）

### 名称解析

- 将username转换为uid，根据名称解析库/etc/passwd进行

### 组类别1

#### 管理员组

- 管理员组组名：root
- 管理员组标识：GID为0

#### 普通用户组

- 普通用户组的GID为1到60000

#### 普通用户组中的系统用户组

- 系统用户组的GID为1-999（7），1-499（6）

#### 普通用户组中的登录用户组

- 登录用户组的GID为1000-60000（7），500-60000（6）

### 名称解析

- 将groupname转换为GID，根据名称解析库/etc/group进行

### 组类别2

- 分为主组和附加组，主组信息在/etc/passwd，附加组信息在/etc/group

### 组类别3

- 分为私有组和公共组
- 私有组，组名和用户名相同，只包含一个用户
- 公共组，组内包含多个用户

### 认证信息

- 通过比对事先存储的信息与登录时提供的信息是否一致
- 用户密码在/etc/shadow中
- 组密码在/etc/gshadow中
- 破解密码方式分为
    - 暴力破解（穷举破解，20位随机密码要破解几百年），解密破解，字典破解三种
- 密码设置方式：
    - 1.不使用常见密码，生日密码，使用随机字符串
    - 2.长度至少8位，推荐20位
    - 3.大小写字母，特殊字符，数字，至少使用3种，推荐4种
    - 4.至少1个月修改一次密码

### 加密方式

- 对称加密：加密和解密使用同一个密码
- 非对称加密：加密和解密使用一对密钥，公钥和私钥，2048位
- 单向加密：只能加密，不能解密，提取数据特征码
    - 1.定长输出
    - 2.雪崩效应（初始条件微小变化，结果巨大变化）
    - 3.常见算法：
        - 1.md5 128位
        - 2.sha1 160位
        - 3.sha224 224位
        - 4.sha256 256位
        - 5.sha384 384位
        - 6.sha512 512位
    - 4.加salt，加盐，随机字串，可以避免两个密码相同，密文相同
    
```
[root@localhost ~]# echo "Hello World"|md5sum
e59ff97941044f85df5297e1c302d260 -
[root@localhost ~]# echo "Hello World"|sha1sum
648a6a6ffffdaa0badb23b8baf90b6168dd16b3a -
[root@localhost ~]# echo "Hello World"|sha224sum
e53ee97e5e0a2a4d359b5b461409dc44d9315afbc3b7d6bc5cd598e6 -
[root@localhost ~]# echo "Hello World"|sha256sum
d2a84f4b8b650937ec8f73cd8be2c74add5a911ba64df27458ed8229da804a26 -
[root@localhost ~]# echo "Hello World"|sha384sum
acbfd470c22c0d95a1d10a087dc31988b9f7bfeb13be70b876a73558be664e5858d11f9459923e6e5fd838cb5708b969 -
[root@localhost ~]# echo "Hello World"|sha512sum
e1c112ff908febc3b98b1693a6cd3564eaf8e5e6ca629d084d9f0eba99247cacdd72e369ff8941397c2807409ff66be64be908da17ad7b8a49a2a26c0e8086aa -
```

### /etc/passwd（7个字段）

- 查看man 5 passwd 需要安装 man-pages
- 然后makewhatis （6） mandb（7）
- 7个字段
- account:password:UID:GID:GECOS:directory:shell
    1. 用户名
    2. 密码占位符x
    3. 用户标识符UID
    4. 组标识符GID
    5. 注释信息
    6. 用户家目录
    7. 用户登录默认shell

```
[root@localhost ~]# head -1 /etc/passwd
root:x:0:0:root:/root:/bin/bash
[root@localhost ~]# yum install -y man-pages
[root@localhost ~]# makewhatis
[root@localhost ~]# whatis passwd
passwd (1) - update user's authentication tokens
passwd (5) - password file
passwd [sslpasswd] (1ssl) - compute password hashes
[root@localhost ~]# man 5 passwd
```

### /etc/shadow（9个字段）

1. 用户名
2. 加密密码（$分隔）
    + 加密算法，6为sha512
    + salt，随机数
    + 加密后密码
3. 最后一次更改密码的日期（从1970年1月1日到最近一次更改密码过了多少天）
    + 0表示下次登录要立即修改密码
    + 空表示功能禁用
4. 密码最小使用期限（从上一次修改密码后至少使用多少天才能更改密码）
5. 密码最大使用期限（从上一次修改密码后最多使用多少天必须更改密码）
6. 密码警告期（密码最大使用期限前提前多少天告知，不改能登录）
7. 密码宽限期（密码最大使用期限后宽限多少天修改，不改不能登录，过了宽限期，禁止登录）
8. 账户过期日期（不管到期不到期，过期不能登录，从1970年1月1日到账户过期日期过了多少天）
9. 保留字段

```
[root@localhost ~]# head -1 /etc/shadow
root:$6$wbGmEQ1TFMzU3OjY$qeykswQFzZ9vscDEMUeHrwu9/X0XP.vViOg1R3nVo18tEPvIZmbs0AUyakydXdJos7MP0leqmWcKQ1O66AaRQ/:17661:0:99999:7:::
```

### /etc/group（4个字段）

1. 组名
2. 占位符x
3. GID
4. user_list 以此组为附加组的改组用户成员

```
[root@localhost ~]# head -1 /etc/group
root:x:0:
```

### /etc/gshadow（4个字段）

1. 组名
2. 加密密码
3. 管理员
4. 组员

```
[root@localhost ~]# head -1 /etc/gshadow
root:::
```
