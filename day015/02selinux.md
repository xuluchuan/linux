# Secure Enhanced Linux
- 内核实现
- MAC:采用强制访问控制
- 两种工作模式：strict每个进程 和 target容易入侵的进程
- subject operation object
- ls -Z ps auxZ 查看selinux属性
- 修改完/etc/selinux/config后，要重启，将所有文件重新打标
- user:role:type 用户 角色 类型

### selinux规则

- 哪种域访问哪些文件，法无授权不可为
- 1.配置selinux，启动要修改/etc/selinux/config SELINUX=enforcing(permissive 只写日志，disable禁用)
    + setenforce 0 关闭 1 开启 ，getenforce 查看
- 2.重新打标
    + chcon -u -r -t 类型 -R递归
    + 还原文件默认标签 restorecon -R /PATH
- 3.设置布尔型开关
    + getsebool -a 查看布尔开关
    + setsebool -P(永久) BOL_NAME on/off 
- 4.审计日志
    + /var/log/audit/audit.log
    
