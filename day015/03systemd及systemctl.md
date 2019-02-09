# Systemd

### 核心概念unit

- 相关配置文件进行标识，识别，配置，管理服务，监听socket，快照，init等
- 路径在/usr/lib/systemd/system
- /run/systemd/system
- /etc/systemd/system

### unit类别

- .service 系统服务
- .target 模拟实现运行级别
- .socket 标识进程间通信用到的socket文件
- .mount 文件系统挂载点
- .device 定义内核识别的设备
- .snapshot 管理系统快照
- .swap 管理swap设备
- .automount 自动挂载
- .path 文件系统目录

### 关键特性

- 基于socket激活，bus，device或path激活
- 有系统快照功能，保存当前unit信息永久存储
- 兼容/etc/init.d/
- 非有systemd启动的无法兼容

### systemctl用法

- 管理服务：systemctl start|stop|restart|status|reload NAME.service
- status：loaded已装载 disabled/enabled 禁用/启用 inactive未激活/active激活
- 条件重启：service NAME condrestart | systemctl try-restart NAME.service
- 重载或重启： systemctl reload-or-restart NAME.service
- 重载或条件式重启：systemctl reload-or-try-restart NAME.service
- 查看服务是否激活：systemctl is-active NAME.service
- 查看所有激活的服务：systemctl list-units -t service 
- 查看所有服务：systemctl list-units -t service -a
- 设置服务开机自启动：systemctl enable NAME.service
- 设置服务取消开机自启动：systemctl disable NAME.service
- 禁止设置开机启动：systemctl mask | unmask NAME.service
- 查看依赖服务：systemctl list-dependencies NAME.service

### 管理target.units

- 0 runlevel0.target poweroff.target
- 1              1.target rescue.target
- 2              2.target multi-user.target
- 3              3.target ...
- 4              4.target ...
- 5              5.target graphical.target
- 6              6.target reboot.target
- init N 设置启动级别：systemctl isolate NAME.target
- runlevel 查看启动级别：systemctl list-units -t target -a 全部
- 获取默认运行级别：systemctl get-default
- 设置默认运行级别：systemctl set-default NAME.target
- 进入救援模式：systemctl rescue
- 进入紧急模式：systemctl emergency
- 其他：systemctl halt/poweroff/reboot/suspend/hibernate（快照）/hybird-sleep（快照并挂起）

### .serivce文件的写法

- 分为三部分：
- 1.[Unit] 与unit有关的通用选项
- 2.[Service] 与特定类型相关的选项
- 3.[Install] systemctl enable|disable 时用到的选项

##### Unit

- Description：描述
- After：启动次序 Before
- Wants：弱依赖
- Requires：强依赖
- Conflicts：冲突关系

##### Service

- Type：类型（simple 主进程 forking oneshot dbus notify idle）
- EnvironmentFile：环境配置路径
- ExecStart：启动运行的脚本
- ExecStop：关闭运行的脚本
- Restart：重启运行的脚本

##### Install

- Alias：别名
- Requires：依赖
- Wants：依赖

##### 修改.service后

- 要执行systemctl daemon-reload

