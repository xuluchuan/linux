# glob及IO重定向

### bash shell基础特性之六 globbing文件名通配

- 匹配模式：元字符
- *：匹配任意长度的（0-n）任意字符
- ?：匹配任意单个字符（1）
- []：匹配指定范围内的任意单个字符（1）
    + [a-z]：不区分大小写，所有字母
    + [0-9]：所有数字
    + [a-z0-9]：所有字母数字
    + [[:upper:]]：所有大写字母
    + [[:lower:]]：所有小写字母
    + [[:alpha:]]：所有字母
    + [[:digit:]]：所有数字
    + [[:alnum:]]：所有字母数字
    + [[:space:]]：所有空白字符
    + [[:punct:]]：所有标点符号
- [^]：匹配指定范围外的任意单个字符
    + [^a-z0-9]：非字母数字
    + [^[:upper:]]：非大写字母

```
[root@localhost ~]# ls -d /etc/*[[:upper:]]*
/etc/DIR_COLORS /etc/GeoIP.conf /etc/NetworkManager
/etc/DIR_COLORS.256color /etc/GeoIP.conf.default /etc/X11
/etc/DIR_COLORS.lightbgcolor /etc/GREP_COLORS
```

### IO重定向

- I可输入设备：键盘设备，常规文件，网卡
- O可输出设备：显示器，常规文件，网卡
- 程序的数据流有三种：
    - 输入数据流：标准输入 stdin 0 键盘
    - 输出数据流：标准输出 stdout 1 显示器
    - 错误输出流：错误输出 stderr 2 显示器
- 重定向分类：
    1. 输出重定向 > 特性：覆盖输出重定向
      + set -C 可以防止覆盖输出重定向覆盖，set +C关闭此功能
    2. 追加输出重定向 >> 特性：追加输出重定向
    3. 错误输出重定向 2> 
    4. 错误追加输出重定向 2>>
    5. 合并正常输出和错误输出 &> 或 > FILE 2>&1
    6. 合并正常追加输出和错误追加输出 &>> 或 >> FILE 2>&1
      + 可以将信息重定向到/dev/null，黑洞设备
    7. 输入重定向 < 
    8. 此处创建文档 <<
    9. 清空文件 :> /FILEPATH 当进程占用时使用

```
cat >/tmp/cat.out <<EOF
1LINE
2LINE
EOF
[root@localhost ~]# ls /var &> /dev/null
[root@localhost ~]# echo $?
0
```

### tr

- 把输入数据中的字符，set1中出现**对位转换**到set2中出现的字符
- tr -d 删除对应字符
- 不会修改文件

```
[root@localhost ~]# tr [a-z] [A-Z] < /etc/issue
CENTOS RELEASE 6.9 (FINAL)
KERNEL \R ON AN \M
[root@localhost ~]# cat /etc/issue
CentOS release 6.9 (Final)
Kernel \r on an \m
[root@localhost ~]# tr -d [a-z] < /etc/issue
COS 6.9 (F)
K \ \
```

### 管道

- 连接程序，实现将前一个命令的输出直接定向到后一个程序中当做输入

```
[root@localhost ~]# cat /etc/issue|tr 'a-z' 'A-Z'
CENTOS RELEASE 6.9 (FINAL)
KERNEL \R ON AN \M
[root@localhost ~]# who|head -1
root tty1 2018-05-18 22:52
```

### tee

- 将一份输入输出2份，1份保留在文件中，1份送到后面命令或直接输出

```
[root@localhost ~]# cat /etc/issue|tee /tmp/issue.txt|tr 'a-z' 'A-Z'
CENTOS RELEASE 6.9 (FINAL)
KERNEL \R ON AN \M
[root@localhost ~]# cat /tmp/issue.txt
CentOS release 6.9 (Final)
Kernel \r on an \m
```
