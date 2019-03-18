# redis其他功能

### 慢查询日志

- slowlog get 查询慢日志
- slowlog len 当前长度
- slowlog reset 重置
- slowlog-max-len 默认长度为128，建议设置为1000以上
- slowlog-log-slower-than 默认时间为10ms，建议设置为1ms

```
config set slowlog-log-slower-than 1000
config set slowlog-max-len 1000
config rewrite
```

- slowlog get 队列持久化到mysql中

### redis shell

#### redis-cli

- -h 主机 -p 端口 -a 密码
- -r  3 重复
- -i 3 间隔

```shell
[root@redis ~]# redis-cli -r 3 -i 1 info|grep used_memory_human
used_memory_human:794.24K
used_memory_human:794.24K
used_memory_human:794.24K
```

- -x 标准输入
- -c cluster
- --scan --pattern 查询指定模式
- --bigkeys 大键
- --latency 延迟
- --stat 统计

#### redis-benchmark

- -r随机插入键
- 默认-c 50个用户
- -n 请求数
- -t 限制命令
- -P pipeline
- -q 静默
- 测试redis性能

```
[root@redis ~]# redis-benchmark -r 1000000 -n 2000000 -t get,set,lpush,lpop -P 16 -q
SET: 641025.69 requests per second
GET: 1005025.12 requests per second
LPUSH: 1079913.62 requests per second
LPOP: 1145475.38 requests per second

[root@redis ~]# redis-cli 
127.0.0.1:6379> dbsize
(integer) 864578
127.0.0.1:6379> flushdb
OK
127.0.0.1:6379> dbsize
(integer) 0
127.0.0.1:6379> exit
[root@redis ~]# redis-benchmark -r 1000000 -n 2000000 -t get,set,lpush,lpop -q
SET: 145836.38 requests per second
GET: 141083.53 requests per second
LPUSH: 141974.88 requests per second
LPOP: 142460.30 requests per second

[root@redis ~]# redis-cli 
127.0.0.1:6379> flushdb
OK
127.0.0.1:6379> dbsize
(integer) 0
127.0.0.1:6379> exit
```


### redis pipeline

- redis瓶颈网络 
- 将多条命令合并为一条
- redis-cli --pipe

### 事务

- watch乐观锁
- multi 事务开始
- exec 执行
- discard撤销

### lua脚本

- redis-cli --eval LUA脚本 
- eval evalsha
- script kill 杀掉脚本
- 原子性

### bitmap

- 节省内存空间
- 使用场景：是否在线 活跃用户
- setbit 设置
- getbit 获取
- bitop 操作

### hyperloglog

- 节省内存空间
- 基数统计
- 有错误 记录总数 ip uv计算

### pub/sub 发布订阅

- publish 发布
- subscribe 订阅
- psubscribe 模式订阅
- unsubscribe 退订
- punsubscribe 模式退订
- 无法持久化
- 应用场景：聊天室

### geo 

- 地理位置数据
- geoadd 

### 持久化

- snapshot 快照
- AOF 附加到文件后 事务日志

### 主从复制

- 主写
- 从读
- 发布 订阅 消息队列


### 3.0

- LRU(Least Recently Used)最近最少使用算法改进
- cluster
- embeded string

### 存储分类

- rdbms 关系型 mysql pgsql
- nosql redis mongodb

### nosql分类

- k-v memcached redis
- column cassandra hbase
- document mongodb
- graph neo4j

### redis组件

- redis-server 服务器
- redis-cli 客户端
- redis-benchmark 压力测试
- redis-check-dump & redis-check-aof rdb/aof 检查持久化工具
- redis版本 3.0.2
- redis.conf配置文件

#### redis.conf

- port 6379
- tcp-backlog 511 缓冲队列
- bind 监听地址
- unixsocket 本地socket
- timeout 客户端超时 0不超时
- logfile 自己记录日志
- databases 16 多少个数据库 默认0号数据库 分布式不支持多库
- save seconds changes 持久化 save "" 禁用持久化
- save 900 1 900秒有1次变化做快照
- save 300 10
- save 60 10000
- 主从：启用从slaveof masterip masterport
- slave-read-only yes 从库只读
- 安全：maxclients 10000 最大并发
- maxmemory 最大内存
- aof 禁用 appendonly on
- redis cluster 
- slowlog 慢查询日志
- latency 延迟 
- event 
- service redis start
- redis-cli 

### redis-cli

- -h 主机
- -p 端口
- -s socket
- -a 密码
- -r 重复
- -i 等待时间
- help命令
- help @string
- help APPEND
- client list
- slaveof host port

### 键值存储

- 键不能重复 不能过长
- SELECT 1 
- SELECT 0 打开数据库

#### String

- String help @string
- help set
- set disto fedora 设置
- get disto 取出
- append disto hello
- strlen disto
- set count 0
- incr count 增加
- decr count 减少
- setex 过期
- setnx 不存在才创建
- setxx 存在才创建

#### List 列表

- help @list
- rpush附加 lpush lpop rpop弹出
- lset key index value 设置
- lpop 弹出
- lpush l1 mon 附加 
- lindex l1 0 取出

#### Set 集合

- 无序 不可重复
- 交差并补
- help @set
- sadd w1 mon tue wed 创建集合
- sinter 求交集
- sunion 求并集
- scard 个数
- sdiff  求差集
- sdiffstore 求差集并存储
- sismember w1 mon 查询是否是元素
- spop key 随机弹出
- sscan 遍历


#### Sorted Set 排序集合

- 有序，不可重复
- help @sorted_set
- zadd 定义有序集合
- zadd weekday1 1 mon 2 tue 3 wed
- zcard 个数
- zcount 指定范围内元素
- zrank weekday1 tue 查看设置索引
- zrange 查看内部索引


#### Hash 映射

- help @hash
- hset h1 a mon
- hget h1 a
- hset h1 b tue 不断的增加新的值
- hscan 遍历
- hkeys 查看所有键
- hvals 查看所有值
- hsetnx 不存在才创建
- hlen h1 查看个数
- hdel key 删除

### bitmaps hyperloglog

### redis 认证

- requirepass STRING密码串
- redis-cli -h ip -a password 或登入后AUTH password

### 清空

- flushdb 清空数据库
- flushall 清空所有库

### 事务功能

- 通过multi exec watch 命令实现事务功能
- multi
- set ip 192.168.1.1
- get ip
- set port 8080
- get port
- exec
- 将一个或多个命令归并为一个操作提请服务器按照顺序执行的机制
- multi 启动事务
- exec 执行事务
- watch 乐观锁 exec 命令执行之前，监视指定数量键，监视修改，拒绝执行
- watch在multi前设置
- redis不支持回滚操作

### connection命令

- auth
- ping 返回pong
- echo "hello redis"
- quit

### 服务端命令

- client getname
- client kill ip:port
- client setname 
- config get 
- info 服务器的状态
- config resetstat 重置info
- config set 运行时修改
- config rewrite 运行时参数写到配置文件
- dbsize 所有键的数量
- bgsave save lastsave 持久化
- monitor 实时监控
- shutdown nosave/save 关闭
- slaveof 配置主从
- showlog 慢查询
- sync 复制

### 发布与订阅

- 消息队列
- publish / subscribe 频道发布/订阅
- subscriber 订阅一个或多个频道 一/多 对 一/多
- help subscribe help @pubsub
- subscribe news
- publish news hello
- unsubscribe news 退订频道
- psubscribe 使用正则表达式 模式订阅

### redis持久化

- rdb redis database snapshot 策略周期性 dump.rdb
- aof append only file

#### RDB

- 默认启用rdb 二进制 snapshot 快照 
- 客户端 保存 save主线程保存，同步阻塞客户端请求 bgsave 异步后台不阻塞
- 会丢失一部分数据
- SAVE 900 1
- SAVE 300 19
- SAVE 60 10000
- stop-writes-on-bgsave-error yes bgsave发生错误会停止写操作
- rdbcompression yes
- rdbchecksum yes
- dbfilename dump.rdb
- dir /var/lib/redis/
- CONFIG GET dir
- CONFIG SET    
- CONFIG REWRITE 写到配置文件

#### AOF

- 附加日志，类似binlog
- 文件变大，有可能多余
- bgrewriteaof 重写aof，快照保存到临时文件，替换AOF，变小
- 不会丢数据
- 重写过程：fork子进程，数据库重建到临时文件，新命令追加到原AOF并发在缓存队列中
- 子进程重写完成，通知父进程，父进程将新命令追加到新AOF
- appendonly no 默认关闭
- appendfilename "appendonly.aof"
- appendfsync everysec 每秒钟写一次 丢一秒
- no-appendfsync-on-rewrite no 重写的过程调用fsync
- auto-aof-rewrite-percentage 100 上次重写的2倍重写
- auto-aof-rewrite-min-size 64Mb 64M 64M重写
- 持久本身不能取代备份，制定备份策略
- rdb 和 aof bgsave和bgrewriteaof不会同时执行
- 恢复数据优先启用AOF

#### 主从复制

- 一个master有多个slave
- 链式复制
- 非阻塞方式同步到slave
- master写操作，slave读操作
- slave 读取 master的数据文件到本地，load到内存中
- SLAVEOF 172.16.100.6 6379 设置从库
- KEYS * 查看所有键
- info REPLICATION 查看复制
- slave-serve-stale-data yes
- slave-read-only 从库只读
- repl-diskless-sync no 无盘复制
- slave-priority slave优先级
- min-slaves-to-write 3 
- min-slaves-max-lag 10 落后10s后主服务器拒绝写入
- 主服务器requirepass 从服务器 masterauth password