# sed 

- 流编辑器 行编辑器
- 工作空间：pattern space，hold space
- 每一行匹配pattern，匹配到的编辑命令修改，没有匹配到的到标准输出
- sed 'script' file

### 选项

- -n：不输出pattern space的标准输出
- -e：指定多个编辑
- -f：/PATH/TO/SED_SCRIPTS_FILE 指定sed脚本
- -r：使用扩展正则表达式
- -i：编辑原文件

### 地址定界

1. 不给地址：全文处理
2. 单地址：
    + \#：指定行 
    + /PATTERN/：此模式匹配到的每一行
3. 地址范围
    + \#,#
    + \#,+#
    + \#,/pattern/
    + /pattern1/,/pattern2/
4. 步近
    + 1~2：奇数行
    + 2~2：偶数行

### 编辑命令

- d：删除
- p：显示
- a \TEXT：（append）在行后面追加，\n多行
- i \TEXT：（insert）在行前插入
- c \TEXT：（change）匹配行替换
- w ：保存
- r：读取，文件合并
- =：打印行号
- !：取反
- s///：查找替换，g：全局替换 w：替换成功保存到文件 p：只显示替换行

```
[root@localhost ~]# cat /etc/fstab |sed -r -e 's/^#[[:space:]]*//g' -e '/^[[:space:]]*$/d'
/etc/fstab
Created by anaconda on Wed May 9 22:52:20 2018
Accessible filesystems, by reference, are maintained under '/dev/disk'
See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
UUID=4f8f9662-22a0-446d-8044-465d2a00b42d / xfs defaults 0 0
UUID=2ffce847-9957-4a54-a48f-ff466fa8a6fa /boot xfs defaults 0 0
UUID=200259c9-e2bb-4768-a136-4e6f2d287686 swap swap defaults 0 0
[root@localhost ~]# sed '7s#disabled#enforcing#g' !$
sed '7s#disabled#enforcing#g' /etc/selinux/config

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
# enforcing - SELinux security policy is enforced.
# permissive - SELinux prints warnings instead of enforcing.
# disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of three two values:
# targeted - Targeted processes are protected,
# minimum - Modification of targeted policy. Only selected processes are protected.
# mls - Multi Level Security protection.
SELINUXTYPE=targeted

```

### 高级编辑命令

- h：模式覆盖保持
- H：模式追加保持
- g：保持覆盖模式
- G：保持追加模式
- x：互换
- n：覆盖匹配下一行到模式空间
- N：追加匹配下一行至模式空间
- d：删除模式行
- D：删除多行模式空间的所有行
- sed '/^$/d;G' 删除所有空白行，原有每行后方添加空白行
