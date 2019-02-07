# shell编程基础

### 脚本格式

- \#!/bin/bash 首行顶格
- 所有注释使用#开头，写脚本信息
    + \# description:
    + \# version:
    + \# author:
    + \# date: 
- 缩进：自动缩进4个空格，适当添加空白行
- 编程语言：包括语法，库，算法，数据结构
- 编程思想：将问题空间变为解空间
- 编程技巧：每一种语言都代表一种思维方式，建议读源码

### 变量

- 变量包括：
    - 局部变量
    - 本地变量
    - 环境变量
    - 位置参数
    - 特殊变量

- 变量数据类型包括：
    - 字符
    - 数值（整数，浮点数（shell本身不支持））

- shell是弱类型语言
    + 默认处理为字符型

- 变量引用：
    + ${}
    + export PATH="$PATH:/usr/local/apache/bin"

- 命令引用：
    + $()或``

- 算术运算
    + \+ - * / % **
    + let VAR=expression
    + VAR=$[expression]
    + VAR=$((expression))
    + VAR=$(expr argu1 op argu3)
    + 乘法*要转义

- 增强型赋值
    + 变量做某种算术运算回存到此变量中
    + += -= *= /= %= **=
    + declare -i i=1
    + i=$[$i+1]
    + let i+=1

- 自增、自减运算
    + let VAR++
    + let VAR--

```
[root@localhost scripts]# cat idSum.sh
#!/bin/bash
# description: 求出/etc/passwd中的第10个和第18个用户ID之和
# ahthor: xuluchuan
# version: 1.0
# date: 20180603
user01=$(sed -n '10p' /etc/passwd | cut -d':' -f1)
user02=$(sed -n '18p' /etc/passwd | cut -d':' -f1)
user01ID=$(id -u $user01)
user02ID=$(id -u $user02)
idSum=$[$user01ID+$user02ID]
echo "两个用户ID之和为：$idSum"
[root@localhost scripts]# cat spaceSum.sh
#!/bin/bash
# description: 计算/etc/rc.d/init.d/functions 和 /etc/inittab的空白行之和
# author: xuluchuan
# version: 1.0
# date: 20180603
# functions的空白行
space1=$(grep "^[[:space:]]*$" /etc/rc.d/init.d/functions | wc -l)
# inittab的空白行
space2=$(grep "^[[:space:]]*$" /etc/inittab | wc -l)
spaceSum=$[$space1+$space2]
echo "两个文件共有空白行的行数为：$spaceSum"
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
```

### 条件测试

- 判断某需求是否满足测试机制
- 执行命令，利用命令状态结果判断
- 测试表达式
    1. test EXPRESSION
    2. [ EXPRESSION ] 表达式前后有空格
    3. [[ EXPRESSION ]] 表达式前后有空格 

#### 数值测试

- -eq 是否等于 equal
- -ne 是否不等于 not equal
- -gt 是否> greater than
- -lt 是否< lower than
- ge 是否≥ greater than or equal
- le 是否≤ lower than or equal

```
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
```

#### 字符串测试

- ==是否等于
- \> 是否大于 ascii码表
- < 是否小于
- !=是否不等于
- =~是否匹配（左侧字符串中部分字符匹配右侧pattern）
- -z "STRING" 判断指定的字符串是否为空
- -n "STRING" 判断指定的字符串是否不空
- 注意：字符串要加引号，字符串比较使用[[ EXPRESSION ]]

```
[root@localhost scripts]# cat stringTest.sh
#!/bin/bash
# description: 字符串测试
# author: xuluchuan
# version: 1.0
# date: 20180603
str1="hello"
str2="el"
if [[ "${str1}" =~ "${str2}" ]];then
    echo "yes"
fi

if [[ "${str1}" == "hello" ]];then
    echo "yes"
fi

if [[ "${str1}" == "h${str2}lo" ]];then
    echo "yes"
fi

if [[ "${str1}" != "${str3}" ]];then
    echo "yes"
fi

if [[ "${str3}" == "" ]];then
    echo "str3没有值"
fi

str3=""

if [[ -z "${str3}" ]];then
    echo "str3没有值"
fi

if [[ -n "${str2}" ]];then
    echo "str2有值"
fi
[root@localhost scripts]# bash stringTest.sh
yes
yes
yes
yes
str3没有值
str3没有值
str2有值
```

#### 脚本状态返回值

- 默认是最后一条命令的状态返回值
- 自定义退出状态码：exit 数字n：n为指定状态码
- 程序遇到exit即终止，整个脚本执行结束

```
[root@localhost scripts]# cat exitCode.sh
#!/bin/bash
# description: 测试自定义状态码
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
if [[ $sum -ne 0 ]];then
    exit 77
fi
[root@localhost scripts]# bash exitCode.sh
1到100的和为：2500
[root@localhost scripts]# echo $?
77
```

#### 文件测试

##### 存在测试

- -a FILE -e FILE 文件是否存在

##### 存在与类型测试

- -b FILE 存在且为块设备
- -c FILE 存在且为字符设备
- -d FILE 存在且为目录
- -f FILE 存在且为普通文件
- -h FILE -L FILE 存在且为符号链接
- -p FILE 存在且为管道文件
- -S FILE 存在且为套接字文件

##### 文件权限测试

- -r FILE 存在且对当前用户可读
- -w FILE 存在且对当前用户可写
- -x FILE 存在且对当前用户可执行

##### 特殊权限测试

+ -u FILE 存在且有suid权限
+ -g FILE 存在且有guid权限
+ -k FILE 存在且有sticky权限

##### 文件是否有内容测试

- -s FILE 存在且内容非空

##### 时间戳测试

- -N FILE 存在且自从上次读操作后是否被修改过

##### 从属关系测试

- -O FILE 存在且当前用户是否为文件属主
- -G FILE 存在且当前用户是否属于文件属组

##### 双目测试

- FILE1 -ef FILE2 测试FILE1与FILE2是否为指向同一个文件系统的相同inode的硬链接（equal file）
- FILE1 -nt FILE2 测试FILE1是否新于FILE2（newer than）
- FILE1 -ot FILE2 测试FILE1是否老于FILE2（older than）

### 组合测试

- COMMAND1 && COMMAND2 命令短路与
- COMMAND1 || COMMAND2 命令短路或
- ! COMMAND 命令非
- [ -O FILE ] && [ -r FILE ]
- [ EXP1 -a EXP2 ] 与
- [ EXP1 -o EXP2 ] 或
- [ ! EXP1 ] 非

### 位置参数变量：向脚本传递参数

- $1 第一个位置参数
- $2 第二个位置参数
- ${10} 第十个位置参数

### 位置参数轮替（shift）

- shift [n]，不写默认轮替一个

### 特殊变量

- \$0：脚本文件路径 basename $0 获取脚本文件名
- $#：保存脚本参数的个数
- $*：所有参数，当n个字符串
- $@：所有参数，当1个字符串

### 过程式编程语言执行特点：

- 顺序执行：逐条执行
- 选择执行：代码有一个分支，当条件满足时执行，有两个或以上的分支，只会执行其中的一个满足条件的分支
- 循环执行：循环体要执行0,1或多个来回

### 单分支选择

```
if 测试条件; then
    代码分支
fi
```

### 双分支选择

```
if 测试条件; then
    代码分支
else
    代码分支
fi
```

### 代码调试

- bash -x 调试
- bash -n 检查语法错误

### 用户交互键盘录入变量

- read -p "" VAR 
- read -t TIMEOUT  超时时间












### 练习1
+ 输入两个数字，输出较大的数字
```
[root@localhost scripts]# cat bigNumber.sh
#!/bin/bash
# description: 输入两个数字，输出较大的数字
# author: xuluchuan
# version: 1.0
# date: 20180604
if [ $# -ne 2 ]; then
    echo "请传入两个数字"
    exit 1
fi
if [ $1 -ge $2 ]; then
    echo "较大的数字为：$1"
else
    echo "较大的数字为：$2"
fi
[root@localhost scripts]# ./bigNumber.sh 3 5
较大的数字为：5
[root@localhost scripts]# ./bigNumber.sh 5 3
较大的数字为：5
```
### 练习2
+ 输入用户名，判断其id为奇数还是偶数
```
[root@localhost scripts]# cat idOdd.sh
#!/bin/bash
# description: 输入用户名，判断其id为奇数还是偶数
# author: xuluchuan
# version: 1.0
# date: 20180604
if [ $# -ne 1 ]; then
    echo "请传入一个用户名"
    exit 1
fi
declare -i idNum
id -u $1 &> /dev/null
if [ $? -ne 0 ]; then
    echo "此用户名不存在"
    exit 2
else
    idNum=$(id -u $1)
fi
if [ $[$idNum%2] -eq 0 ]; then
    echo "用户${1} id${idNum}为偶数"
else
    echo "用户${1} id${idNum}为奇数"
fi
[root@localhost scripts]# ./idOdd.sh
请传入一个用户名
[root@localhost scripts]# ./idOdd.sh bash
用户bash id1001为奇数
[root@localhost scripts]# ./idOdd.sh hadoop
用户hadoop id1000为偶数
[root@localhost scripts]# ./idOdd.sh rooter
此用户名不存在
```

### 练习3
+ 输入两个文件，输出行数较大的文件
```
[root@localhost scripts]# cat bigFile.sh
#!/bin/bash
# description: 输入两个文件，输出行数较大的文件
# author: xuluchuan
# version: 1.0
# date: 20180604
if [ $# -ne 2 ]; then
    echo "请传入两个文件"
    exit 1
fi
if [ ! -f $1 -o ! -f $2 ]; then
    echo "文件不存在或不是文件"
    exit 2
fi
declare -i lineFile1=$(wc -l $1 | cut -d' ' -f1)
declare -i lineFile2=$(wc -l $2 | cut -d' ' -f1)
if [ $lineFile1 -ge $lineFile2 ]; then
    echo "文件行数最多的为：$1"
else
    echo "文件行数最多的为：$2"
fi
[root@localhost scripts]# ./bigFile.sh idSum.sh sum100.sh
文件行数最多的为：sum100.sh
[root@localhost scripts]# ./bigFile.sh idSum.sh
请传入两个文件
[root@localhost scripts]# ./bigFile.sh idSum.sh sum100
文件不存在或不是文件
```
### 练习4 计算键盘录入的两个整数之和
```
[root@localhost scripts]# cat readTest.sh
#!/bin/bash
#!/bin/bash
# description: 计算键盘录入的两个整数之和
# author: xuluchuan
# version: 1.0
# date: 20180604
read -p "请输入第一个整数：" int1
read -p "请输入第二个整数：" int2
declare -i intSum=$[${int1}+${int2}]
echo "两个数之和为：$intSum"
[root@localhost scripts]# bash -x readTest.sh
+ read -p $'\350\257\267\350\276\223\345\205\245\347\254\254\344\270\200\344\270\252\346\225\264\346\225\260\357\274\232' int1
请输入第一个整数：33
+ read -p $'\350\257\267\350\276\223\345\205\245\347\254\254\344\272\214\344\270\252\346\225\264\346\225\260\357\274\232' int2
请输入第二个整数：22
+ declare -i intSum=55
+ echo $'\344\270\244\344\270\252\346\225\260\344\271\213\345\222\214\344\270\272\357\274\23255'
两个数之和为：55
```
