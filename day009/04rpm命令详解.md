# rpm命令详解

### rpm的安装

- -i：安装（install）
- -v：显示详细信息
- -h：显示进度条，50个#，每个#为2%
- -ivh：安装并显示详细信息和进度条
- --test：只测试不安装
- --nodeps：忽略依赖关系
- --releasepkgs：重装（修改后的配置文件不会替换，除非删除才替换）
- --noscripts：不执行安装脚本
    + rpm自带脚本分为
    + 1.安装前脚本：preinstall %pre --nopre 不执行
    + 2.安装后脚本：postinstall %post --nopost 不执行
    + 3.卸载前脚本：preuninstall %preun --nopreun 不执行
    + 4.卸载后脚本：postuninstall %postun --nopostun 不执行
- --nosignature：不检查签名信息，不检查来源
- --nodigest：不检查完整性

### rpm的升级

- -Uvh：升级或安装（没有安装旧版本就安装）（update）
- -Fvh：升级（没有安装旧版本不安装）（freshen）
- --oldpackage：降级安装
- --force：强制升级（忽略包的依赖关系）
- 注意
    1. 不要对内核做升级操作，linux支持多内核共存，可以直接安装新内核
    2. 原程序配置文件修改后，升级后不会覆盖，会把新版本文件命名为FILENAME.rpmnew后提供

### rpm卸载

- -e：卸载 （erase）
- --allmatches：卸载所有的匹配指定名称的包
- --nodeps：忽略依赖关系
- --noscripts：不执行脚本
- --test：测试

### rpm查询

- -q：查询是否安装及安装版本（query）
- -qa：查询所有安装的包
- -qf FILE_PATH：查询指定文件由哪个安装包生成
- -qg：查询包组有哪些包
- -qp FILE.rpm：查询未安装的rpm包中安装后能生成哪些文件
- -q --whatprovides CAPABILITY：查询指定的CAPABILITY是哪些包提供
- -q --whatrequires CAPABILITY：查询指定的CAPABILITY被哪些包依赖
- -q --changelog：查询changelog
- -ql：查询文件列表
- -qi：查询info
- -qc：查询配置文件
- -qd：查询说明文档
- -q --provides：查询有包内有哪些CAPABILITY
- -qR：查询依赖关系
- -q --scripts：查询脚本

```

[root@localhost ~]# rpm -qa|grep bash
bash-4.2.46-28.el7.x86_64
[root@localhost ~]# rpm -qf /bin/bash
bash-4.2.46-28.el7.x86_64
[root@localhost ~]# rpm -qg bash
group bash does not contain any packages
[root@localhost ~]# rpm -q --whatprovides /bin/bash
bash-4.2.46-28.el7.x86_64
[root@localhost ~]# rpm -q --whatrequires /bin/bash
nss-softokn-freebl-3.28.3-6.el7.x86_64
iproute-3.10.0-87.el7.x86_64
grubby-8.28-23.el7.x86_64
openssl-1.0.2k-8.el7.x86_64
rpm-4.11.3-25.el7.x86_64
openldap-2.4.44-5.el7.x86_64
policycoreutils-2.5-17.1.el7.x86_64
teamd-1.25-5.el7.x86_64
device-mapper-1.02.140-8.el7.x86_64
dracut-033-502.el7.x86_64
kmod-20-15.el7.x86_64
systemd-219-42.el7.x86_64
initscripts-9.49.39-1.el7.x86_64
crontabs-1.11-6.20121102git.el7.noarch
dhclient-4.2.5-58.el7.centos.x86_64
dracut-network-033-502.el7.x86_64
ebtables-2.0.10-15.el7.x86_64
plymouth-scripts-0.8.9-0.28.20140113.el7.centos.x86_64
firewalld-0.4.4.4-6.el7.noarch
kexec-tools-2.0.14-17.el7.x86_64
audit-2.7.6-3.el7.x86_64
postfix-2.10.1-6.el7.x86_64
openssh-server-7.4p1-11.el7.x86_64
dracut-config-rescue-033-502.el7.x86_64
iprutils-2.4.14.1-1.el7.x86_64
man-db-2.6.3-9.el7.x86_64
selinux-policy-targeted-3.13.1-166.el7.noarch
[root@localhost ~]# rpm -q --changelog bash|head -3
* Tue Mar 07 2017 Kamil Dudka <kdudka@redhat.com - 4.2.46-28
- CVE-2016-9401 - Fix crash when '-' is passed as second sign to popd
  Resolves: #1429838

[root@localhost ~]# rpm -ql bash
/etc/skel/.bash_logout
/etc/skel/.bash_profile
/etc/skel/.bashrc
/usr/bin/alias
/usr/bin/bash
/usr/bin/bashbug
/usr/bin/bashbug-64
/usr/bin/bg
/usr/bin/cd
/usr/bin/command
/usr/bin/fc
/usr/bin/fg
/usr/bin/getopts
/usr/bin/jobs
/usr/bin/read
/usr/bin/sh
/usr/bin/umask
/usr/bin/unalias
/usr/bin/wait
/usr/share/doc/bash-4.2.46
/usr/share/doc/bash-4.2.46/COPYING
/usr/share/info/bash.info.gz
/usr/share/locale/af/LC_MESSAGES/bash.mo
/usr/share/locale/bg/LC_MESSAGES/bash.mo
/usr/share/locale/ca/LC_MESSAGES/bash.mo
/usr/share/locale/cs/LC_MESSAGES/bash.mo
/usr/share/locale/de/LC_MESSAGES/bash.mo
/usr/share/locale/en@boldquot/LC_MESSAGES/bash.mo
/usr/share/locale/en@quot/LC_MESSAGES/bash.mo
/usr/share/locale/eo/LC_MESSAGES/bash.mo
/usr/share/locale/es/LC_MESSAGES/bash.mo
/usr/share/locale/et/LC_MESSAGES/bash.mo
/usr/share/locale/fi/LC_MESSAGES/bash.mo
/usr/share/locale/fr/LC_MESSAGES/bash.mo
/usr/share/locale/ga/LC_MESSAGES/bash.mo
/usr/share/locale/hu/LC_MESSAGES/bash.mo
/usr/share/locale/id/LC_MESSAGES/bash.mo
/usr/share/locale/ja/LC_MESSAGES/bash.mo
/usr/share/locale/lt/LC_MESSAGES/bash.mo
/usr/share/locale/nl/LC_MESSAGES/bash.mo
/usr/share/locale/pl/LC_MESSAGES/bash.mo
/usr/share/locale/pt_BR/LC_MESSAGES/bash.mo
/usr/share/locale/ro/LC_MESSAGES/bash.mo
/usr/share/locale/ru/LC_MESSAGES/bash.mo
/usr/share/locale/sk/LC_MESSAGES/bash.mo
/usr/share/locale/sv/LC_MESSAGES/bash.mo
/usr/share/locale/tr/LC_MESSAGES/bash.mo
/usr/share/locale/uk/LC_MESSAGES/bash.mo
/usr/share/locale/vi/LC_MESSAGES/bash.mo
/usr/share/locale/zh_CN/LC_MESSAGES/bash.mo
/usr/share/locale/zh_TW/LC_MESSAGES/bash.mo
/usr/share/man/man1/..1.gz
/usr/share/man/man1/:.1.gz
/usr/share/man/man1/[.1.gz
/usr/share/man/man1/alias.1.gz
/usr/share/man/man1/bash.1.gz
/usr/share/man/man1/bashbug-64.1.gz
/usr/share/man/man1/bashbug.1.gz
/usr/share/man/man1/bg.1.gz
/usr/share/man/man1/bind.1.gz
/usr/share/man/man1/break.1.gz
/usr/share/man/man1/builtin.1.gz
/usr/share/man/man1/builtins.1.gz
/usr/share/man/man1/caller.1.gz
/usr/share/man/man1/cd.1.gz
/usr/share/man/man1/command.1.gz
/usr/share/man/man1/compgen.1.gz
/usr/share/man/man1/complete.1.gz
/usr/share/man/man1/compopt.1.gz
/usr/share/man/man1/continue.1.gz
/usr/share/man/man1/declare.1.gz
/usr/share/man/man1/dirs.1.gz
/usr/share/man/man1/disown.1.gz
/usr/share/man/man1/enable.1.gz
/usr/share/man/man1/eval.1.gz
/usr/share/man/man1/exec.1.gz
/usr/share/man/man1/exit.1.gz
/usr/share/man/man1/export.1.gz
/usr/share/man/man1/fc.1.gz
/usr/share/man/man1/fg.1.gz
/usr/share/man/man1/getopts.1.gz
/usr/share/man/man1/hash.1.gz
/usr/share/man/man1/help.1.gz
/usr/share/man/man1/history.1.gz
/usr/share/man/man1/jobs.1.gz
/usr/share/man/man1/let.1.gz
/usr/share/man/man1/local.1.gz
/usr/share/man/man1/logout.1.gz
/usr/share/man/man1/mapfile.1.gz
/usr/share/man/man1/popd.1.gz
/usr/share/man/man1/pushd.1.gz
/usr/share/man/man1/read.1.gz
/usr/share/man/man1/readonly.1.gz
/usr/share/man/man1/return.1.gz
/usr/share/man/man1/set.1.gz
/usr/share/man/man1/sh.1.gz
/usr/share/man/man1/shift.1.gz
/usr/share/man/man1/shopt.1.gz
/usr/share/man/man1/source.1.gz
/usr/share/man/man1/suspend.1.gz
/usr/share/man/man1/times.1.gz
/usr/share/man/man1/trap.1.gz
/usr/share/man/man1/type.1.gz
/usr/share/man/man1/typeset.1.gz
/usr/share/man/man1/ulimit.1.gz
/usr/share/man/man1/umask.1.gz
/usr/share/man/man1/unalias.1.gz
/usr/share/man/man1/unset.1.gz
/usr/share/man/man1/wait.1.gz
[root@localhost ~]# rpm -qi bash
Name        : bash
Version     : 4.2.46
Release     : 28.el7
Architecture: x86_64
Install Date: Wed 09 May 2018 10:53:47 PM CST
Group       : System Environment/Shells
Size        : 3663637
License     : GPLv3+
Signature   : RSA/SHA256, Thu 10 Aug 2017 11:03:40 PM CST, Key ID 24c6a8a7f4a80e                                          b5
Source RPM  : bash-4.2.46-28.el7.src.rpm
Build Date  : Thu 03 Aug 2017 05:13:21 AM CST
Build Host  : c1bm.rdu2.centos.org
Relocations : (not relocatable)
Packager    : CentOS BuildSystem <http://bugs.centos.org>
Vendor      : CentOS
URL         : http://www.gnu.org/software/bash
Summary     : The GNU Bourne Again shell
Description :
The GNU Bourne Again shell (Bash) is a shell or command language
interpreter that is compatible with the Bourne shell (sh). Bash
incorporates useful features from the Korn shell (ksh) and the C shell
(csh). Most sh scripts can be run by bash without modification.
[root@localhost ~]# rpm -qc bash
/etc/skel/.bash_logout
/etc/skel/.bash_profile
/etc/skel/.bashrc
[root@localhost ~]# rpm -qd bash
/usr/share/doc/bash-4.2.46/COPYING
/usr/share/info/bash.info.gz
/usr/share/man/man1/..1.gz
/usr/share/man/man1/:.1.gz
/usr/share/man/man1/[.1.gz
/usr/share/man/man1/alias.1.gz
/usr/share/man/man1/bash.1.gz
/usr/share/man/man1/bashbug-64.1.gz
/usr/share/man/man1/bashbug.1.gz
/usr/share/man/man1/bg.1.gz
/usr/share/man/man1/bind.1.gz
/usr/share/man/man1/break.1.gz
/usr/share/man/man1/builtin.1.gz
/usr/share/man/man1/builtins.1.gz
/usr/share/man/man1/caller.1.gz
/usr/share/man/man1/cd.1.gz
/usr/share/man/man1/command.1.gz
/usr/share/man/man1/compgen.1.gz
/usr/share/man/man1/complete.1.gz
/usr/share/man/man1/compopt.1.gz
/usr/share/man/man1/continue.1.gz
/usr/share/man/man1/declare.1.gz
/usr/share/man/man1/dirs.1.gz
/usr/share/man/man1/disown.1.gz
/usr/share/man/man1/enable.1.gz
/usr/share/man/man1/eval.1.gz
/usr/share/man/man1/exec.1.gz
/usr/share/man/man1/exit.1.gz
/usr/share/man/man1/export.1.gz
/usr/share/man/man1/fc.1.gz
/usr/share/man/man1/fg.1.gz
/usr/share/man/man1/getopts.1.gz
/usr/share/man/man1/hash.1.gz
/usr/share/man/man1/help.1.gz
/usr/share/man/man1/history.1.gz
/usr/share/man/man1/jobs.1.gz
/usr/share/man/man1/let.1.gz
/usr/share/man/man1/local.1.gz
/usr/share/man/man1/logout.1.gz
/usr/share/man/man1/mapfile.1.gz
/usr/share/man/man1/popd.1.gz
/usr/share/man/man1/pushd.1.gz
/usr/share/man/man1/read.1.gz
/usr/share/man/man1/readonly.1.gz
/usr/share/man/man1/return.1.gz
/usr/share/man/man1/set.1.gz
/usr/share/man/man1/sh.1.gz
/usr/share/man/man1/shift.1.gz
/usr/share/man/man1/shopt.1.gz
/usr/share/man/man1/source.1.gz
/usr/share/man/man1/suspend.1.gz
/usr/share/man/man1/times.1.gz
/usr/share/man/man1/trap.1.gz
/usr/share/man/man1/type.1.gz
/usr/share/man/man1/typeset.1.gz
/usr/share/man/man1/ulimit.1.gz
/usr/share/man/man1/umask.1.gz
/usr/share/man/man1/unalias.1.gz
/usr/share/man/man1/unset.1.gz
/usr/share/man/man1/wait.1.gz
[root@localhost ~]# rpm -q --provides bash
/bin/bash
/bin/sh
bash = 4.2.46-28.el7
bash(x86-64) = 4.2.46-28.el7
config(bash) = 4.2.46-28.el7
[root@localhost ~]# rpm -qR bash
/bin/sh
config(bash) = 4.2.46-28.el7
libc.so.6()(64bit)
libc.so.6(GLIBC_2.11)(64bit)
libc.so.6(GLIBC_2.14)(64bit)
libc.so.6(GLIBC_2.15)(64bit)
libc.so.6(GLIBC_2.2.5)(64bit)
libc.so.6(GLIBC_2.3)(64bit)
libc.so.6(GLIBC_2.3.4)(64bit)
libc.so.6(GLIBC_2.4)(64bit)
libc.so.6(GLIBC_2.8)(64bit)
libdl.so.2()(64bit)
libdl.so.2(GLIBC_2.2.5)(64bit)
libtinfo.so.5()(64bit)
rpmlib(BuiltinLuaScripts) <= 4.2.2-1
rpmlib(CompressedFileNames) <= 3.0.4-1
rpmlib(FileDigests) <= 4.6.0-1
rpmlib(PayloadFilesHavePrefix) <= 4.0-1
rtld(GNU_HASH)
rpmlib(PayloadIsXz) <= 5.2-1
[root@localhost ~]# rpm -q --scripts bash
postinstall scriptlet (using <lua>):
nl        = '\n'
sh        = '/bin/sh'..nl
bash      = '/bin/bash'..nl
f = io.open('/etc/shells', 'a+')
if f then
  local shells = nl..f:read('*all')..nl
  if not shells:find(nl..sh) then f:write(sh) end
  if not shells:find(nl..bash) then f:write(bash) end
  f:close()
end
postuninstall scriptlet (using <lua>):
-- Run it only if we are uninstalling
if arg[2] == "0"
then
  t={}
  for line in io.lines("/etc/shells")
  do
    if line ~= "/bin/bash" and line ~= "/bin/sh"
    then
      table.insert(t,line)
    end
  end

  f = io.open("/etc/shells", "w+")
  for n,line in pairs(t)
  do
    f:write(line.."\n")
  end
  f:close()
end
```

### rpm检验

- -V：（verify）
- 若没有返回值，则没被修改

### rpm包的来源合法性和完整性验证

- 合法性通过数字签名来验证（开发者用私钥加密单项提取的特征码做成数字签名）
- 使用者拿到公钥，如能匹配私钥则证明来源合法
- 如果两个特征码相同，则证明程序完整
- 关键点：合法获取公钥
- 获取并导入信任的包制作者公钥：rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
- 验证方式：
    1. 安装时自动验证
    2. 手工验证：rpm -K 

###  数据库重建

- 数据库在/var/lib/rpm
- --initbuild：初始化数据库
- --rebuilddb：重新构建数据库

### rpm包自制

- 下载源码
- rpmbuild 制作
- 重要制作SPEC文件


