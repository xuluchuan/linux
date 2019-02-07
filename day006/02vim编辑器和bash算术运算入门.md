# vim编辑器和bash算术运算入门

### vim 末行模式

#### 1.地址定界

- :# 特定第#行
- :#,# 左侧起始行，右侧结束行
- :#,+# 左侧绝对起始行，右侧相对左侧
- :.当前行
- :.,+3
- :$ 最后一行
- :.,$-1
- :1,$ 全文
- :% 全文
- /pattern/ 第一次被模式匹配到的行
- /pattern/,$
- /pattern1/,/pattern2/ 第一次被模式1匹配到的行到第一次被模式2匹配到的行
- 可以与d y c 命令一起使用
- 范围w /path/to/somewhere 范围内文本保存到文件中
- 范围r /path/to/somewhere 文件读取合并

#### 2.查找

- /pattern 从当前光标所在处向文件尾部查找字符串
- ?pattern 从当前光标所在处向文件首部查找字符串
- n与命令方向相同 N与命令方向相反 下一个

#### 3.查找并替换

- s/查找内容/替换为内容/修饰符
- 查找内容可以使用基本正则表达式，使用|要转义
- 替换为内容不能使用正则，但可以使用后项引用\1和全文引用&符号
- 默认只查找替换每行的第一个字符
- 修饰符 i 忽略大小写，g全局替换
- 分隔符还可使用### @@@

### vim多文件操作

#### 多文件单窗口

- vim file1 file2
- :next 切换到下一个 :prev 切换到上一个 :first 切换到第一个 :last 切换到最后一个
- 退出所有文件: :wqall :qall :wall

#### 多文件多窗口

- -o 水平分隔
- -O 垂直分隔
- 使用ctrl+w,上下左右箭头 切换下一个

#### 单文件多窗口

- ctrl+w,s水平分隔 ctrl+w,v垂直分隔

### 定制vim工作特性

1. 行号 :set nu 显示行号 :set nonu 不显示行号 
2. 匹配括号高亮：:set sm 打开高亮 :set nosm 关闭高亮
3. 自动缩进：:set ai 打开缩进 :set noai 关闭缩进
4. 搜索高亮：set hlsearch 打开 :set nohlsearch
5. 语法高亮：syntax on 打开 syntax off关闭
6. 忽略大小写：set ic 打开 :set noic 关闭
7. 获取帮助： :help :help SUBJECT
8. tab 缩进4个空格：
9. 末行模式设置的临时生效
10. 全局设置：/etc/vimrc
11. 个人用户设置：~/.vimrc

```
[root@localhost ~]# cat .vimrc
set nu
set smartindent
set nohlsearch
set tabstop=4
set shiftwidth=4
set expandtab
set softtabstop=4
```

### 算术运算

1. let sum=$num1+$num2
2. sum=$[$num1+$num2]
3. sum=$(($num1+$num2))
4. sum=$(expr $num1 + $num2)

```
[root@localhost ~]# num1=1
[root@localhost ~]# num2=2
[root@localhost ~]# echo "$num1+$num2"
1+2
[root@localhost ~]# let sum=$num1+$num2
[root@localhost ~]# echo $sum
3
[root@localhost ~]# sum=$[$num1+$num2]
[root@localhost ~]# echo $sum
3
[root@localhost ~]# sum=$(($num1+$num2))
[root@localhost ~]# echo $sum
3
[root@localhost ~]# sum=$(expr $num1 + $num2)
[root@localhost ~]# echo $sum
3
```





