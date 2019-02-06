# grep与基本正则表达式

### 三剑客

- grep文本过滤工具
- sed 流编辑器
- awk gawk 文本报告生成器，格式化文本

### 正则表达式

- Regular Expression
- 由一类特殊字符和文本字符所编写的模式，其中有些字符不表示字面意思，用于表示控制或通配的功能。
- 基本正则表达式 BRE
- 扩展正则表达式 ERE

### grep（Global search Regular Expression and Print out the line）

- 文本搜索工具，根据用户指定的模式（过滤条件）对目标文本逐行匹配检查，打印匹配到的行
- 模式：正则表达式的元字符和文本字符编写的过滤条件
- 用法：grep [OPTIONS] PATTERN [FILE...]
- -i (ignorecase) 忽略大小写
- -o(only) 仅显示匹配到的字符串本身
- -v(invert) 显示不能匹配到的行
- -E(扩展正则表达式)
- -q(quiet) 不输出信息
- -A(after) # 输出下几行
- -B(before) # 输出上几行
- -C(context) # 输出上下各几行
- -n 显示行号

### 基本正则表达式元字符

#### 字符匹配

- **.** 匹配任意单个字符
- [] 匹配指定范围内的任意单个字符
- [^] 匹配指定范围外的任意单个字符 
    - [[:digit:]]  [0-9]数字
    - [[:lower:]] [a-z]小写字母
    - [[:upper:]] [A-Z]大写字母
    - [[:alpha:]] [a-zA-Z] 字母
    - [[:alnum:]] [0-9a-zA-Z]字母数字
    - [[:punct:]]标点符号
    - [[:space:]]空白字符
    
#### 匹配次数（前面字符出现的次数）

- \* 0-n次
- .* 匹配任意长度的任意字符（默认贪婪模式，尽可能匹配最长）
- \\? 0-1次
- \\+ 1-n次
- \\{m\\} m次
- \\{m,n\\} m-n次
- \\{0,n\\} 最多n次
- \\{m,\\} 最少m次

```
[root@localhost ~]# echo "r1OOt"|grep "r[0-9a-zA-Z]\{3\}t"
r1OOt
[root@localhost ~]# echo "r1OOt"|grep -i "r[0-9a-z]\{3\}t"
r1OOt
[root@localhost ~]# grep -o "root" /etc/passwd
root
root
root
root
[root@localhost ~]# grep -v "/bin/bash$" /etc/passwd
[root@localhost ~]# grep -A 1 "ftp" /etc/passwd
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
[root@localhost ~]# grep -B 1 "ftp" /etc/passwd
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
[root@localhost ~]# grep -nC 1 "ftp" /etc/passwd
11-games:x:12:100:games:/usr/games:/sbin/nologin
12:ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
13-nobody:x:99:99:Nobody:/:/sbin/nologin

```

#### 位置锚定

- ^ 行首锚定，模式最左侧
- $ 行尾锚定，模式最右侧
- ^$ 空白行
- ^[[:space:]]*$ 空白行或只包含空白字符的行
- 单词：非特殊字符组成的连续字符串
- \< 或 \b 词首锚定，单词最左侧
- \\> 或 \b 词尾锚定，单词最右侧
-  \bWORD\b \\<\WORD\\> 单词精确锚定

```
[root@localhost ~]# grep -n "\<root\>" /etc/passwd
1:root:x:0:0:root:/root:/bin/bash
10:operator:x:11:0:operator:/root:/sbin/nologin
[root@localhost ~]# grep -v "^#" /etc/fstab|grep -v "^[[:space:]]*$"
UUID=4f8f9662-22a0-446d-8044-465d2a00b42d / xfs defaults 0 0
UUID=2ffce847-9957-4a54-a48f-ff466fa8a6fa /boot xfs defaults 0 0
UUID=200259c9-e2bb-4768-a136-4e6f2d287686 swap swap defaults 0 0
```

#### 分组引用

- \\(\\) 将一个或多个字符捆绑在一起，当一个整体处理
- 后项引用：分组括号中模式匹配到的内容记录到后面的变量中，\1为第一个括号中的内容， \2为第二个括号中的内容，依次类推
 
```
[root@localhost ~]# cat -n back.sh
     1 hello
     2 hello # hello
     3     # hello
     4 # hello
     5
     6
[root@localhost ~]# grep -Env "^[[:space:]]*$|^[[:space:]]*#" back.sh|sed -r 's/(.*)#(.*)/\1/g'
1:hello
2:hello
[root@localhost ~]# echo "root root"|grep "\(\<r..t\>\).*\1"
root root
[root@localhost ~]# echo "reet reet"|grep "\(\<r..t\>\).*\1"
reet reet
[root@localhost ~]# echo "root reet"|grep "\(\<r..t\>\).*\1"
```
