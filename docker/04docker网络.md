# docker网络

## 四大网络

- bridge 桥接网络 暴露端口 bridged container 默认
- 联盟式网络 joined container docker间为局域网  
- host 共享主机网络 open container
- none 无网络 closed container
- docker container inspect web1 检查网络ip

```shell
[root@docker2 ~]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
2bcd030f7adb        bridge              bridge              local
8c731372c575        host                host                local
9b4db230f4b0        none                null                local
```


## 创建容器指定网络

- 默认 --network bridge
- none --network none
- 主机 --network host
- --hostname 启动时加入hostname
- --dns 设置dns
- --rm 运行完后删除
- --add-host 增加/etc/hosts文件解析
- 使用桥接时 使用 -p HostPort:containerPort暴露端口
- -P 暴露所有端口
- docker port 查看端口
- --network container:b1 b2设置为和b1同一个网络空间
- “Bridge”网络会增加额外消耗，大概12%
- 生产环境建议使用host模式，使用端口区分容器
- 如果容器需要使用不同ip则使用calico网络模型


## 自定义网络

### 自定义docker0

- /etc/docker/daemon.json
- `"bip": "10.0.0.1/16"`

### 自定义网桥

- docker network create
- --net mybr