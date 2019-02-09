# bash循环

### 循环控制语句

- continue 提前结束本轮循环，直接进入下一轮循环
- break 提前结束循环

```
[root@centos7-mould scripts]# cat 100oddSum.sh
#!/bin/bash
# description: 100之内的奇数和
# author: xuluchuan
# version: 1.0
# date: 20180706
declare -i sum=0
declare -i i=0
while [ $i -lt 100 ]; do
    let i++
    if [ $[$i%2] -eq 0 ]; then
        continue
    fi
    let sum+=$i
done
echo "sum: $sum"
[root@centos7-mould scripts]# bash 100oddSum.sh
sum: 2500
```

### 死循环用break跳出

```
while true; do
    循环体
    break
done
```

### sleep

- sleep 3 等待3秒钟

### while循环特殊用法

- 遍历文件的每一行

```
while read line; do
    循环体
done < /PATH/FROM/SOMEFILE
```

- 测试

```
[root@centos7-mould scripts]# cat passwd.sh
#!/bin/bash
# description: 显示偶数uid的用户名
# author: xuluchuan
# version: 1.0
# date: 20180706
while read line; do
    username=`echo $line|cut -d: -f1`
    uid=`echo $line|cut -d: -f3`
    if [ $[$uid%2] -eq 0 ];then
        echo "$username $uid" >> /tmp/passwd.log
    fi
done < /etc/passwd
[root@centos7-mould scripts]# bash passwd.sh
[root@centos7-mould scripts]# cat /tmp/passwd.log
root 0
daemon 2
lp 4
shutdown 6
mail 8
games 12
ftp 14
systemd-network 192
sshd 74
```

### for循环特殊用法

```
for ((控制变量初始化; 条件判断; 控制变量修正语句)); do
    循环体
done
```

- 控制变量初始化只在开始时执行一次
- 每轮循环结束时先执行控制变量修正语句，后进行条件判断

```
[root@centos7-mould scripts]# cat 99multiply.sh
#!/bin/bash
# description: 99乘法表
# author: xuluchuan
# version: 1.0
# date: 20180706
for ((i=1; i<=9; i++)); do
    for ((j=1; j<=i; j++)); do
        echo -n -e "${j}X${i}=$[${j}*${i}]\t"
    done
    echo
done
[root@centos7-mould scripts]# bash 99multiply.sh
1X1=1
1X2=2 2X2=4
1X3=3 2X3=6 3X3=9
1X4=4 2X4=8 3X4=12 4X4=16
1X5=5 2X5=10 3X5=15 4X5=20 5X5=25
1X6=6 2X6=12 3X6=18 4X6=24 5X6=30 6X6=36
1X7=7 2X7=14 3X7=21 4X7=28 5X7=35 6X7=42 7X7=49
1X8=8 2X8=16 3X8=24 4X8=32 5X8=40 6X8=48 7X8=56 8X8=64
1X9=9 2X9=18 3X9=27 4X9=36 5X9=45 6X9=54 7X9=63 8X9=72 9X9=81
```

### 跳出多重循环

- break 2 跳出2层循环

### case语句

```
case $VARIABLE in
PAT1)
    分支1
    ;;
PAT2)
    分支2
    ;;
*)
    分支n
    ;;
esac
```

- PAT支持glob语法，*任意0到多个字符，?任意单个，[]范围内任意一个，a|b 或

```
[root@centos7-mould scripts]# cat /etc/init.d/testservice
#!/bin/bash
# chkconfig: - 80 80
# description: testservice
prog=$(basename $0)
lockfile=/var/lock/subsys/$prog
case $1 in
start)
    if [ -f $lockfile ]; then
        echo "$prog is running!"
    else
        touch $lockfile
        echo "$prog start."
    fi
    ;;
stop)
    if [ ! -f $lockfile ]; then
        echo "$prog is not running!"
    else
        rm -f $lockfile
        echo "$prog stop."
    fi
    ;;
restart)
    if [ ! -f $lockfile ]; then
        echo "$prog is not running!"
        touch $lockfile
        echo "$prog start."
    else
        rm -f $lockfile
        echo "$prog stop."
        touch $lockfile
        echo "$prog start."
    fi
    ;;
status)
    if [ ! -f $lockfile ]; then
        echo "$prog is not running!"
    else
        echo "$prog is running!"
    fi
    ;;
*)
    echo "USAGE: start|stop|restart|status"
    exit 2
    ;;
esac
```

### 函数

- 函数是一段完成独立功能的一个整体，有一个名字，是一个命名的代码段
- 函数只有调用才能执行，自动替换为函数代码块，调用时创建，返回时终止
- 函数使用函数名直接调用
- 函数格式

```
function f_name {
    函数体
}
f_name() {
    函数体
}
```

#### 函数执行结果返回值

- 1.使用echo或printf
- 2.使用函数体重命令的执行结果

#### 函数的退出状态码

- 1.默认是最后一条命令的状态码
- 2.使用return [0-255] 0为正确，其他错误

#### 函数可以接受参数

- 使用func arg1 arg2传递，在函数中使用$1 $2 $* $@ 引用参数，$#是参数个数
- 使用retval=$?接受函数的退出状态码

```
[root@centos7-mould scripts]# cat /etc/init.d/testservice
#!/bin/bash
# chkconfig: - 80 80
# description: testservice
prog=$(basename $0)
lockfile=/var/lock/subsys/$prog
start() {
    if [ -f $lockfile ]; then
        echo "$prog is running!"
    else
        touch $lockfile
        echo "$prog start."
    fi
}

stop() {
    if [ ! -f $lockfile ]; then
        echo "$prog is not running!"
    else
        rm -f $lockfile
        echo "$prog stop."
    fi
}

status() {
    if [ ! -f $lockfile ]; then
        echo "$prog is not running!"
    else
        echo "$prog is running!"
    fi
}

usage() {
    echo "USAGE: start|stop|restart|status"
    exit 2
}

case $1 in
start)
    start
    ;;
stop)
    stop
    ;;
restart)
    stop
    start
    ;;
status)
    status
    ;;
*)
    usage
    ;;
esac
```

- nn乘法表

```
[root@centos7-mould scripts]# cat nnmultiply.sh
#!/bin/bash
# description: nn乘法表
# author: xuluchuan
# version: 1.0
# date: 20180706
nnmultiply() {
    for ((i=1; i<=$1; i++)); do
        for ((j=1; j<=i; j++)); do
            echo -n -e "${j}X${i}=$[${j}*${i}]\t"
        done
        echo
    done
}
if [ ! $# -eq 1 ]; then
    echo "pls input one number from 1 to 9!"
elif [ $1 -ge 1 -a $1 -le 9 ]; then
    nnmultiply $1
else
    echo "pls input number from 1 to 9!"
fi
```

#### 变量作用域

- 局部变量：函数内部，当函数结束后自动销毁，格式 local VARIABLE=VALUE
- 本地变量：生命周期是脚本所在的shell进程

#### 函数递归

- 直接或间接调用自身

```
[root@centos7-mould scripts]# cat jiecheng.sh
#!/bin/bash
# description: 阶乘
# author: xuluchuan
# version: 1.0
# date: 20180707
jiecheng() {
    if [ $1 -eq 1 ]; then
        echo 1
    else
        echo $[$1*$(jiecheng $[$1-1])]
    fi
}
jiecheng $1
```
