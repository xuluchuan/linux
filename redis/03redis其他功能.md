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