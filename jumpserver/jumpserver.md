# 文档地址
`http://docs.jumpserver.org/zh/docs/`

## 快速入门

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