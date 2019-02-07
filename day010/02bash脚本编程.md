# bash脚本编程

### bash脚本结构

- 顺序
- 选择（&& || ，if语句，case语句）
- 循环（for，while，until）

### if多分支

```
if CONDITION1; then
    条件1成立执行的分支
elif CONDITION2; then
    条件2成立执行的分支
else
    其他分支
fi
```

- 注意：if语句可以嵌套

```
[root@localhost scripts]# cat whichType.sh
#!/bin/bash
# description: 给定文件路径，判定文件类型
# author: xuluchuan
# version: 1.0
# date: 20180611
[ ! $# -eq 1 ] && echo "need 1 argument" && exit 1

if [ ! -e $1 ]; then
    echo "path not existes"
    exit 2
fi

if [ -f $1 ]; then
    echo "normal file"
elif [ -d $1 ]; then
    echo "directory"
elif [ -L $1 ]; then
    echo "link file"
elif [ -b $1 ]; then
    echo "block device"
elif [ -c $1 ]; then
    echo "character device"
elif [ -p $1 ]; then
    echo "pipe"
elif [ -S $1 ]; then
    echo "socket"
else
    echo "unknown"
fi
[root@localhost scripts]# bash whichType.sh
need 1 argument
[root@localhost scripts]# echo $?
1
[root@localhost scripts]# bash whichType.sh whichType.sh
normal file
[root@localhost scripts]# bash whichType.sh /etc/
directory
[root@localhost scripts]# bash whichType.sh /dev/sda1
block device
```

### 循环执行

- 将一段代码重复执行0,1或多次
- 进入条件：条件满足时才进入循环
- 退出条件：每个循环都有退出条件，以有机会退出
- for，while，until

### for循环

1. 遍历列表
2. 控制变量

### for遍历列表

```
for VARIABLE in LIST; do
    循环体
done
```

- 进入条件：列表有元素
- 退出条件：所有条件遍历完成

### LIST

1. 直接给出
2. 整数列表
    1. {start..end}
    2. \`seq [start] [increment] end`
3. 返回列表的命令
4. glob
5. 变量引用，如\$*，$@

```
[root@localhost scripts]# cat sum100.sh
#!/bin/bash
# description: 计算1到100的和
# author: xuluchuan
# version: 1.0
# date: 20180603
declare -i sum=0
for i in `seq 1 100`
do
    let sum+=i
done
echo "1到100的和为：$sum"
[root@localhost scripts]# bash sum100.sh
1到100的和为：5050
[root@localhost scripts]# cat sum100odd.sh
#!/bin/bash
# description: 计算1到100的奇数和
# author: xuluchuan
# version: 1.0
# date: 20180603
declare -i sum=0
for i in `seq 1 100`
do
    if [[ i%2 -eq 1 ]];then
        let sum+=i
    fi
done
echo "1到100的和为：$sum"
[root@localhost scripts]# bash sum100odd.sh
1到100的和为：2500
[root@localhost scripts]# cat lsPath.sh
#!/bin/bash
# description: 遍历路径
# author: xuluchuan
# version: 1.0
# date: 20180611
cd /root/scripts
for file in `ls`; do
    echo $file
done
```
