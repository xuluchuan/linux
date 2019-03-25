# 文档地址
`http://docs.jumpserver.org/zh/docs/`

## 总体介绍
欢迎来到 Jumpserver 文档。

Jumpserver 是全球首款完全开源的堡垒机, 使用 GNU GPL v2.0 开源协议, 是符合 4A 的专业运维审计系统。

Jumpserver 使用 Python / Django 进行开发, 遵循 Web 2.0 规范, 配备了业界领先的 Web Terminal 解决方案, 交互界面美观、用户体验好。

Jumpserver 采纳分布式架构, 支持多机房跨区域部署, 中心节点提供 API, 各机房部署登录节点, 可横向扩展、无并发访问限制。

改变世界, 从一点点开始。

## 安装

一站式、分布式安装文档
可用于生产环境参考安装文档

### 组件说明
Jumpserver 为管理后台, 管理员可以通过Web页面进行资产管理、用户管理、资产授权等操作
Coco 为 SSH Server 和 Web Terminal Server 。用户可以通过使用自己的账户登录 SSH 或者 Web Terminal 直接访问被授权的资产。不需要知道服务器的账户密码
Luna 为 Web Terminal Server 前端页面, 用户使用 Web Terminal 方式登录所需要的组件
Guacamole 为 Windows 组件, 用户可以通过 Web Terminal 来连接 Windows 资产 (暂时只能通过 Web Terminal 来访问)
端口说明
Jumpserver 默认端口为 8080/tcp 配置文件在 jumpserver/config.yml
Coco 默认 SSH 端口为 2222/tcp, 默认 Web Terminal 端口为 5000/tcp 配置文件在 coco/config.yml
Guacamole 默认端口为 8081/tcp
Nginx 默认端口为 80/tcp
Redis 默认端口为 6379/tcp
Mysql 默认端口为 3306/tcp

### 分布式安装

分布式部署文档 - 环境说明
说明
本文档适用于有一定web运维经验的管理员或者工程师, 文中不会对安装的软件做过多的解释, 仅对需要执行的内容注部分注释, 更详细的内容请参考一步一步安装。

环境
系统: CentOS 7
数据库 IP: 192.168.100.10
Redis ip: 192.168.100.20
Jumpserver IP: 192.168.100.30
Coco IP: 192.168.100.40
Guacamole IP: 192.168.100.50
Nginx 代理 IP: 192.168.100.100
Protocol    Server name Port    Used By
TCP Jumpserver  80, 8080    Nginx, Coco, Guacamole
TCP Coco    2222, 5000  Nginx
TCP Guacamole   8081    Nginx
TCP Db  3306    Jumpserver
TCP Redis   6379    Jumpserver
TCP Nginx   80, 2222    All
Nginx 多组件注意 upstream 的负载模式, 需要解决 session 问题

安全
ssh、telnet协议 资产的防火墙设置允许 coco 与 jumpserver 访问

rdp协议 资产的防火墙设置允许 guacamole 与jumpserver 访问

其他
最终用户都是通过 Nginx 反向代理访问。 如需要做 HA 或 负载, 按照如上方式部署多个应用, 数据库做主从, 然后在 nginx 代理服务器用负载即可(四层)。 注意：录像需要自己手动同步或者存放在公共目录。
```shell
[root@jump-server ~]# if [ "$SECRET_KEY" = "" ]; then SECRET_KEY=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 50`; echo "SECRET_KEY=$SECRET_KEY" >> ~/.bashrc; echo $SECRET_KEY; else echo $SECRET_KEY; fi
6mNvf0Zhn2Q8acwH141GzBPze6xachxgkgzWQoWlAzdGulCJZP
[root@jump-server ~]# if [ "$BOOTSTRAP_TOKEN" = "" ]; then BOOTSTRAP_TOKEN=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 16`; echo "BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN" >> ~/.bashrc; echo $BOOTSTRAP_TOKEN; else echo $BOOTSTRAP_TOKEN; fi
KLp0cHi4mhHSz2wW
[root@jump-server ~]# docker run --name jms_all -d -p 37777:80 -p 3333:2222 -e SECRET_KEY=$SECRET_KEY -e BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN jumpserver/jms_all:latest
```
## 快速入门
https://www.jetbrains.com/
`http://docs.jumpserver.org/zh/docs/admin_create_asset.html`

## 创建管理用户

```
3.1.2 创建管理用户

# "管理用户"是资产上的 root, 或拥有 NOPASSWD: ALL sudo 权限的用户, Jumpserver 使用该用
户来推送系统用户、获取资产硬件信息等

# 如果使用ssh私钥管理资产, 需要先在资产上设置, 这里举个例子供参考(本例登录资产使用root为例)
(1). 在资产上生成 root 账户的公钥和私钥

  $ ssh-keygen -t rsa  # 默认会输入公钥和私钥文件到 ~/.ssh 目录

(2). 将公钥输出到文件 authorized_keys 文件, 并修改权限

  $ cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
  $ chmod 400 ~/.ssh/authorized_keys

(3). 打开RSA验证相关设置

  $ vi /etc/ssh/sshd_config

  RSAAuthentication yes
  PubkeyAuthentication yes
  AuthorizedKeysFile     .ssh/authorized_keys

(4). 重启 ssh 服务
  $ service sshd restart

(5). 上传 ~/.ssh 目录下的 id_rsa 私钥到 jumpserver 的管理用户中

# 这样就可以使用 ssh私钥 进行管理服务器
# 名称可以按资产树来命名。用户名root。密码和 SSH 私钥必填一个
```