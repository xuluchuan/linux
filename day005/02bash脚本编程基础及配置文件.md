# bash脚本编程基础及配置文件

### 编程分类

1. 根据运行方式，可以将编程分为解释执行和编译执行
    + 编译执行过程：源代码→编译器编译→程序文件
    + 解释执行过程：源代码→运行时启动解释器，由解释器边解释边执行
    + 解释执行性能比编译执行差
2. 根据编程过程中功能的实现是调用库还是调用外部的程序文件，分为脚本编程和完整编程
    + 脚本编程：利用系统上的命令及编程组件编程
    + 完整编程：利用库及编程组件编程
3. 根据编程模型分为过程式和面向对象式
    + 过程式：以指令为中心组织代码，数据服务于代码
    + 对象式：以数据为中心组织代码，指令服务于数据

- shell是一种过程式，解释的脚本编程语言

### 写shell脚本

- 第一行：#!/bin/bash 顶格，给出解释器路径
- 文本全屏编辑器：nano，vi
- 文本行编辑器：sed
- nano：ctrl+o保存，ctrl+x退出

```
[root@localhost scripts]# yum -y install nano
[root@localhost scripts]# nano myfirst.sh 
[root@localhost scripts]# cat myfirst.sh
#!/bin/bash
echo "Hello World"
touch abc.txt && echo "ok"

[root@localhost scripts]# bash myfirst.sh
Hello World
ok
```

### shell脚本如何写？

- 命令的堆积：很多命令无法重复执行，需要用程序来判断运行条件是否满足，以避免发生错误

### shell脚本如何运行

- 1.赋予执行权限，直接运行
    + chmod +x myfirst.sh
    + ./myfirst.sh
- 2.解释器执行
    + bash myfirst.sh

### shell注意事项

- 1.空白行会被解释器忽略
- 2.脚本中除了第一行，#开头为注释行

### bash的配置文件

- profile类，交互式登录shell
- bashrc类，非交互式登录shell
- 交互式登录
    + 1.直接通过终端输入账号密码
    + 2.su - 或 su -l 
- 非交互式登录
    + 1.su 
    + 2.图形界面的终端
    + 3.运行脚本，为子shell进程

### profile类

- 全局：/etc/profile /etc/profile.d/*.sh
- 个人：~/.bash_profile
- 用途：1.定义环境变量2.运行命令或脚本

### bashrc类

- 全局：/etc/bashrc ~/.bashrc
- 个人：~/.bashrc
- 用途：1.定义本地变量2.定义命令别名
- 注：仅管理员可以修改全局配置文件

### 执行顺序

- 交互式：/etc/profile→/etc/profile.d/*.sh→~/.bash_profile→~/.bashrc→/etc/bashrc
- 非交互式：~/.bashrc→/etc/bashrc→/etc/profile.d/*.sh
- 修改配置文件后仅对当前shell有效，立即生效需要用source或.加载
