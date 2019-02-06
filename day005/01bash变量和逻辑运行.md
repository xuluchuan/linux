# bash变量和逻辑运行

### bash shell基础特性之七 命令hash

- hash命令缓存此前命令的查找结果，只缓存命令，和参数无关
- 是一种key-value的数据格式
- -d 删除命令
- -r 清空命令

```
[root@localhost ~]# ls
anaconda-ks.cfg random.sh random.txt
[root@localhost ~]# hash
hits command
   1 /usr/bin/ls
[root@localhost ~]# rm -f random.sh
[root@localhost ~]# hash
hits command
   1 /usr/bin/rm
   1 /usr/bin/ls
[root@localhost ~]# rm -f random.txt
[root@localhost ~]# hash
hits command
   2 /usr/bin/rm
   1 /usr/bin/ls
[root@localhost ~]# hash -d ls
[root@localhost ~]# hash
hits command
   2 /usr/bin/rm
[root@localhost ~]# hash -r
[root@localhost ~]# hash
hash: hash table empty
```

### bash shell基础特性之八 变量分类

- 程序=指令+数据
- 指令为程序文件
- 数据来自IO设备，文件，管道，变量
- 程序=算法+数据结构
- 变量是最基本的一种数据结构
- 数组，链表，树状是复杂的数据结构
- 变量由变量名和与之对应的内存空间组成
- 变量赋值：把数据存放到变量名对应的内存空间中去 name=value
- 变量类型：一旦确定，则存储格式，数据范围，参与运算都确定
- 根据对变量类型区分的严格程度，分为强类型语言和弱类型语言
- bash shell为弱类型语言
- bash shell把所有变量都视为字符类型
- bash shell不支持浮点，除非借用外部工具
- bash shell无需事先声明变量就可以使用
- 只声明，没有赋值的变量赋值为null
- 变量引用：${var_name} $var_name，把变量名出现的位置替换为所指向内存空间中的数据
- 变量声明：说明变量类型，定义变量名称
- 变量命名法则：
    - 1.使用字母，数字，下划线，不能以数字开头
    - 2.不能使用保留字，如 if else while for
    - 3.见名知意，驼峰法则，首单词首字母小写，其余单词首字母大写

- bash的变量类型（根据作用域不同划分）

#### 1.本地变量

- 仅对当前shell有效（子进程无效）
- 变量赋值：name=value
- 变量引用：${name}或$name
- set命令查看所有的本地变量
- unset 命令 ，撤销本地变量

#### 2.环境变量

- 对当前shell和子进程有效
- 变量引用和本地变量相同
- 变量赋值：
    1. export name=value或 name=value;export name
    2. declare -x name=value或name=value;declare -x name
- declare:
    + -x 声明环境变量
    + -i 声明整型变量
    + -a 声明数组变量
    + -r 声明只读变量（无法撤销，无法修改 或 readonly 变量）
- bash内嵌的环境变量全部为大写
- 四种方式查看环境变量
    - 1.export
    - 2.declare -x
    - 3.printenv
    - 4.env
- unset 命令 ，撤销环境变量
- 存活时间为当前shell进程的生命周期

#### 3.局部变量

- 代码片段有效

#### 4.位置变量

- $1,$n,${10} 位置

#### 5.特殊变量

- $? 成功与否

### bash shell基础特性之九 多命令执行

- 顺序多命令执行
    + 用分号隔开可以执行多个命令，依次执行
- 短路与多命令执行
    + 格式为：COMMAND1 && COMMAND2
    + 如果1成功，则运行2，如果1失败，则2不运行
- 短路或多命令执行
    + 格式为：COMMAND1 || COMMAND2
    + 如果1成功，则2不运行，如果1失败，则运行2

```
[root@localhost tmp]# mkdir abc && echo "yes"
yes
[root@localhost tmp]# mkdir abc && echo "yes"
mkdir: cannot create directory ‘abc’: File exists
[root@localhost tmp]# id mysql || useradd mysql
id: mysql: no such user
[root@localhost tmp]# id mysql || useradd mysql
uid=1000(mysql) gid=1000(mysql) groups=1000(mysql)
[root@localhost tmp]# userdel -r mysql
```
