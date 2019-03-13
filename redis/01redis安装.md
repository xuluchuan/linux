# redis
### redis特性
- remote dictionary server 远程字典服务器
- 每秒50万QPS 读写性能
- C语言实现
- key value 键值存储 cache store
- 内存中实现
- 访问性能高
- 周期写入磁盘，持久化
- 单线程服务器
- epoll io多路复用
- 支持lua脚本
- 支持主从架构高可用
- redis cluster 分布式集群去中心化

### 数据结构

- String 字符串
- List 列表
- Hash 哈希
- Set 集合
- Sorted set 有序集合
- Bitmap 位图
- Hyperloglogs
- GEO
- 100万 100M String
- 每秒50万并发 QPS

### 功能

- 键过期功能：缓存
- 发布订阅功能：消息系统
- lua脚本：新redis命令
- 事务功能：一定事务特性
- 流水线功能：一次传递，减少网络开销
- 持久化：rdb，aof 内存到磁盘的持久化
- redis replication复制功能：分布式系统
- redis sentinel 高可用 故障发现和故障自动转移
- redis cluster 负载均衡 分布式集群

### 应用场景

- 缓存
- 排行榜
- 计数器
- 社交网络
- 消息队列

### 不可以做

- 存储大量用户数据
- 存储冷数据
- 适合存储小量的热点数据


### 安装

```shell
[root@redis ~]# yum -y install redis
[root@redis ~]# systemctl start redis.service
[root@redis ~]# ps -ef|grep redis
redis      1697      1  0 15:01 ?        00:00:00 /usr/bin/redis-server 127.0.0.1:6379
root       1702   1574  0 15:01 pts/0    00:00:00 grep --color=auto redis
[root@redis ~]# systemctl enable redis.service
[root@redis ~]# redis-cli -v
redis-cli 3.2.12
```

### 命令

- redis-server 启动redis
- redis-cli 客户端
- redis-benchmark 基准测试
- redis-check-aof aof检测
- redis-check-dump rdb检测
- redis-sentinel 启动哨兵

### redis-server

- systemctl start redis.service
- 配置文件启动 redis-server /etc/redis.conf
- 日志文件 /var/log/redis/redis.log 
- 端口 6379

```shell
[root@redis ~]# cat /var/log/redis/redis.log 
1697:C 11 Mar 15:01:08.018 * supervised by systemd, will signal readiness
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 3.2.12 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in standalone mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 6379
 |    `-._   `._    /     _.-'    |     PID: 1697
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

1697:M 11 Mar 15:01:08.019 # Server started, Redis version 3.2.12
1697:M 11 Mar 15:01:08.019 * The server is now ready to accept connections on port 6379
```

### redis-cli

- redis-cli -h host -p port command
- redis-cli 默认 127.0.0.1 6379
- redis-cli shutdown 关闭服务
- redis-cli shutdown save 关闭服务并持久化 nosave 不持久化