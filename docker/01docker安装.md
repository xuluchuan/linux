# docker

### 容器概念

- 容器是基础工具，容纳内容物，封闭或完全封闭，保护

### lxc

- linux container

#### 主机级别虚拟化

- 主机级别虚拟化：vmvare workstation
    + Type 1 硬件平台装虚拟机 hypervisor 
    + Type 2 vmvare workstation virtual box 宿主机上装模拟器，创建虚拟机
- 虚拟机需要部署完整的操作系统
- 资源开销大

#### 用户空间级别虚拟化(容器技术)

- 进程隔离，沙箱，不受其他进程干扰
- jail vserver(chroot)
- namespaces 名称空间隔离机制内核级6种隔离资源
    + ipc 进程间通信独立 不能跨用户空间
    + uts 主机名和域名独立 
    + mount 根文件系统独立
    + pid 独立进程树，根树为1的init
    + user 用户独立 (内核3.6才支持 centos7支持)
    + net 网络独立
- 系统调用输出 clone setns 
- 所有用户空间同属于一个内核
- cpu可压缩资源，内存不可压缩资源
- 内核级cgroups(控制组)实现 限制用户资源 分配 1:2:1 封顶
- chroot 沙箱进程隔离
- namespaces 名称空间 隔离6种内核级资源
- cgroups 控制组，限制用户资源 

### lxc(linux container)

- lxc-create
- template 仓库模板(脚本)
- 大规模创建困难
- docker是lxc的增强版

### docker原理

- lxc的二次封装发行
- 创建容器：镜像技术 放在仓库里
- 一个容器中只运行一个main进程，容器间通信
- 调试不方便，分发，部署容易
- 编排工具发布
- 批量创建镜像：下载一次，分层构建，联合挂载，centos底层只读镜像，三个上层只读镜像
- 容器里不能放数据，使用外置的持久化外部存储
- 容器有生命周期，随着进程终止而终止
- 容器编排：启动关闭次序 machine+swarm+compose mesos+marathon k8s
- CNCF：libcontainer runC容器引擎

### docker架构

- dockerhub 镜像
- Client端(build pull run)，docker_host端(docker daemon,containers,images)，registry端（镜像库,https/http协议）
- aliyun docker加速镜像
- 企业版：dockeree 社区版：dockerce moby
- registry：认证，索引，仓库
- 镜像：仓库名+标签，默认最新版 nginx:1.10 nginx:latest nginx:stable
- 镜像(静态)和容器(动态)的关系就是文件和进程的关系

### docker对象

- 镜像
- 容器
- 网络
- 卷
- 插件
- 都可以增删改查

### 安装使用docker

- 64位 cpu
- 3.10+ kernel
- cgroups namespaces
- centos7 extras repository  不建议
- 清华大学 docker ce docker-ce.repo
- 复制查找替换为清华大学源

```
[root@docker ~]# wget -O /etc/yum.repos.d/docker-ce.repo https://download.docker.com/linux/centos/docker-ce.repo 
[root@docker ~]# sed -i 's+download.docker.com+mirrors.tuna.tsinghua.edu.cn/docker-ce+' /etc/yum.repos.d/docker-ce.repo
[root@docker ~]# yum -y install docker-ce
```

- 配置文件：/etc/docker/daemon.json
- 镜像加速器：官方 docker-cn 阿里云
- daemon.json 

``` json
{
    "registry-mirrors": ["https://registry.docker-cn.com"]
}
```

```
[root@docker ~]# mkdir /etc/docker/
[root@docker ~]# vim /etc/docker/daemon.json
{
    "registry-mirrors": ["https://registry.docker-cn.com"]
}
[root@docker ~]# systemctl start docker.service
[root@docker ~]# systemctl enable docker.service
[root@docker2 ~]# docker -v
Docker version 18.09.3, build 774a1f4
```
