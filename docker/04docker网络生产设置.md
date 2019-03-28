# docker网络生产环境设置

## 四大网络

```shell
[root@docker2 ~]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
2bcd030f7adb        bridge              bridge              local
8c731372c575        host                host                local
9b4db230f4b0        none                null                local
```

- bridge 桥接网络 
- joined container 联合网络 
- host 共享主机网络 
- none 无网络


## 创建容器指定网络

- 默认bridge 桥接网络  `--network bridge`
- 使用桥接时 使用 `-p HostPort:containerPort`暴露端口
- none 无网络 `--network none`
- host 共享主机网络 `--network host`
- joined container 联合网络  `--network container:b1` b2设置为和b1同一个网络空间
- Bridge网络会增加额外消耗，大概12%
- 生产环境建议使用主机模式，`--network host` 同一主机容器的ip相同，使用端口区分容器
- 如果容器需要使用不同ip则使用calico网络模型