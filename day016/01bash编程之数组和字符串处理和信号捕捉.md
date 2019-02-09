# bash高级

### 数组

- 存储多个元素的连续内存空间
- 索引机制，从0开始
- bash4之后可以自定义索引 即关联数组
- 声明数组：declare -a NAME 索引数组
- declare -A NAME 关联数组
- 引用方式：${ARRAY_NAME[INDEX]}
- 赋值方式：
    + 1.一次只赋值一个：ARRAY_NAME[INDEX]=VALUE
    + 2.一次赋值多个：ARRAY_NAME=("VAL1" "VAL2" "VAL3")
    + 3.稀疏格式数组：ARRAY_NAME=([0]="VAL1" [3]="VAL3")
    + 4.read -a ARRAY_NAME 输入用空格隔开
- 数组长度：${#ARRAY_NAME[*]}
- 字符个数：${#ARRAY_NAME}
- 数组所有元素：${ARRAY_NAME[*]}
- 0-99随机数：rand[$i]=$[$RANDOM%100]
- 文件路径数组：files=("/var/log/*.log")
- 遍历：for i in $(seq 0 $[${#ARRAY_NAME[*]}-1])
- 数组元素切片：${ARRAY_NAME[@]:OFFSET:NUMBER}
- OFFSET为偏移量，NUMBER为取得个数
- 追加元素：ARRAY_NAME[${#ARRAY_NAME[*]}]=VALUE
- 删除元素：unset ARRAY_NAME[INDEX]
- 关联数组：
    + declare -A ARRAY_NAME
    + ARRAY_NAME=([INDEX_NAME1]="VA1" [INDEX_NAME2]="VAL2")
```
[root@centos7-mould ~]# cat array.sh
#!/bin/bash
# description: 测试数组
# date: 20180710
declare -a names
names=("joe" "jim" "peter")
for i in $(seq 0 $[${#names[*]}-1]); do
    echo "${names[$i]}"
done
echo ${names[*]}
echo ${names[*]:1:2}
[root@centos7-mould ~]# bash array.sh
joe
jim
peter
joe jim peter
jim peter
```

### 字符串处理

- 字符串切片 ${var:offset:number}
- 倒着切：${var: -length}
- 基于模式取子串：
    + ${var#*word} 从左到右找word，第一个之前删除
    + ${var##*word} 从左到右找word，最后一个之前删除
    + ${var%word*} 从右到左找word，第一个之后删除
    + ${var%%word*} 从右到左找word，最后一个之后删除
- 查找替换
    + ${var/PATTERN/SUBSI} 查找第一次出现并替换
    + ${var//PATTERN/SUBSI} 查找所有都替换
    + ${var/#PATTERN/SUBSI} 锚定行首替换
    + ${var/%PATTERN/SUBSI} 锚定行尾替换
- 查找删除
    + ${var/PATTERN}
- 大小写转换
    + ${var^^} 小转大
    + ${var,,} 大转小
- 变量赋值
    + ${var:-VALUE} var为空则value，否则var
    + ${var:=VALUE} var为空则value,并赋值给var，否则var
    + ${var:+VALUE} var不为空则value，否则空
    + ${var:?ERROR_INFO} var为空返回错误信息，否则var

```
[root@centos7-mould ~]# cat url.sh
#!/bin/bash
#description: 字符串测试
url="http://www.baidu.com/pics/abc.jpg"
echo ${url#*/}
echo ${url##*/}
echo ${url%/*}
echo ${url%%/*}
[root@centos7-mould ~]# bash url.sh
/www.baidu.com/pics/abc.jpg
abc.jpg
http://www.baidu.com/pics
http:
```

### 信号捕捉

- trap -l 列出所有信号
- 不能捕捉9 SIGKILL 15 SIGTERM
- 一般捕捉INT HUP
- 使用方式：trap 'COMMAND 或 函数' INT/HUP

### 颜色

- echo -e "\033[31mhello\033[0m"
- 左侧# 3前景 4背景
- 右侧# 1-7 颜色
- 单个#：加粗，闪烁等功能
- 可以用;隔开

### dialog
- 窗口化编程
