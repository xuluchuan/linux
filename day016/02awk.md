# awk

- awk就是gawk
- awk [options] 'program' FILE ...
- program =  PATTERN{ACTION STATEMENTS;}

### options

- -F：指定分隔符 -F "[: +]" 指定多个分隔符
- -v var=value 定义变量
- 原理是处理每行$0，根据分隔符切片为$1,$2

### print

- print $1,$2：逗号为分隔符，显示为空白
- 也可以跟字符串，数值，变量，表达式
- 如果省略item相当于print $0

```
[root@centos7-mould ~]# awk -F "[- ]" '{print $1}' /etc/fstab

#
#
#
#
#
#
#
UUID=4f8f9662
UUID=2ffce847
UUID=200259c9
```

### 变量

- 内建变量：$0 $1
    + FS 输入分隔符
    + OFS 输出分隔符
    + RS 输入换行符
    + ORS 输出换行符
    + NF 字段数
    + $NF 打印最后一个字段
    + NR 行号
    + FNR 每个文件的行号
    + FILENAME 文件名
    + ARGC 参数个数
    + ARGV 参数数组
- 自定义变量：-v 或 program中

```
[root@centos7-mould ~]# awk -F "[- ]" -v OFS="\n" '{print $1,$2}' /etc/fstab


#

#
/etc/fstab
#
Created
#

#
Accessible
#
See
#

UUID=4f8f9662
22a0
UUID=2ffce847
9957
UUID=200259c9
e2bb
[root@centos7-mould ~]# awk -F "[- ]" -v ORS="\t" '{print $1}' /etc/fstab
        # # # # # # # UUID=4f8f9662 UUID=2ffce847 UUID=200259c9 [
[root@centos7-mould ~]# awk -F "[- ]" '{print NR}' /etc/fstab
1
2
3
4
5
6
7
8
9
10
11
[root@centos7-mould ~]# awk -F "[- ]" '{print NF}' /etc/fstab
0
1
2
11
1
9
12
1
43
39
39
[root@centos7-mould ~]# awk -F "[- ]" '{print $NF}' /etc/fstab

#
/etc/fstab
2018
#
'/dev/disk'
info
#
0
0
0
[root@centos7-mould ~]# awk -F "[- ]" '{print FNR}' /etc/fstab /etc/hosts
1
2
3
4
5
6
7
8
9
10
11
1
2
[root@centos7-mould ~]# awk -F "[- ]" 'BEGIN{for (i in ARGV) print ARGV[i];print ARGC}' /etc/fstab
awk
/etc/fstab
2
```

### printf

- 格式化输出
- printf FORMAT,item1,item2
- FORMAT必填项
- 不会自己换行，需要\n
- 格式符号：
    + %c 字符
    + %d 整数
    + %e 科学计数法
    + %f 浮点数
    + %g %G 科学计数法或浮点数
    + %s 字符串
    + %u 无符号整数
    + %% %分号
- 修饰符：%3.1f 左边为宽度，右边为精度，-可以左对齐，+显示数值的+号， 默认右对齐

```
[root@centos7-mould ~]# awk -F "[- ]" 'BEGIN{CMD="cmd\n";HELLO="hello\n";printf "%10s%10s",CMD,HELLO}' /etc/fstab
      cmd
    hello
```

### 操作符

- 算术 +x 转为数值
- 字符串操作符：空就可以字符串连接
- 赋值
- 比较
- 模式匹配 ~ !~
- 逻辑
- 函数调用 func_name(arg1,arg2)
- 条件表达式 selector?if-true:if-false

```
[root@centos7-mould ~]# awk -F "[- ]" 'BEGIN{CMD="cmd\n";HELLO="hello\n";YES=(HELLO=="hello\n")?"true\n":"false\n";printf "%10s",YES}' /etc/fstab
     true
```

### PATTERN

- 空：处理每一行
- /RE/ ：正则表达式
- (条件表达式) ：条件表达式
- 地址定界：/PAT1/,/PAT2/

```
[root@centos7-mould ~]# awk -F " " '/o$/{print $NF}' /etc/fstab
info
[root@centos7-mould ~]# awk -F " " '(NR>=3&&NR<=4){print $NF}' /etc/fstab
/etc/fstab
2018
```

### BEGIN/END

- BEGIN{} 仅在开始处理前执行一次
- END{} 仅在完成后执行一次

### ACTION

- 表达式
- 控制语句
- 组合语句
- 输入语句
- 输出语句

### 控制语句

- if() {} else {}
- while() {}
- do {} while()
- for(;;) {}
- break continue
- delete array[index] delete array exit
- for(var in array) {}
- switch() {case:value1;statement;case:value2;statement;default;statement}
- next 行间未执行完处理下一行，类似continue

### 数组

- array[index]
- 可以是任意字符串
- 数组如果不存在，自动创建空数组
- 判断是否存在 index in array
- weekdays["day1"]="sunday";
- 遍历：for(var in array) {print array[var]}

```
[root@centos7-mould ~]# ss -tna|awk -F " " '(NR!=1){STATE[$1]++}END{for(i in STATE) {print i,STATE[i]}}'
LISTEN 3
ESTAB 1
```

### 函数

- 内置函数
    + rand() 0-1随机数
    + sin() cos()
    + length() 字符串长度
    + sub(r,s,t) 将t中r替换为s，第一次出现
    + gsub(r,s,t) 全局替换
    + split(s,a,r) 将s按r切割放到a数组，下标从1开始
    
```
[root@centos7-mould ~]# ss -tna|awk -F " " '(NR!=1){gsub("L","l",$1);print $1}'
lISTEN
lISTEN
ESTAB
lISTEN
[root@centos7-mould ~]# ss -tna|awk -F " " '(NR!=1){split($1,ARRAY,"E");for(i in ARRAY) {print ARRAY[i]};print "----"}'
LIST
N
----
LIST
N
----

STAB
----
LIST
N
----
```
