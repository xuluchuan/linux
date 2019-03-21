# redis客户端

### java客户端

- jedis
- 支持pipeline 和 lua脚本

### python客户端

- redis-py

### 客户端api

- client list  客户端列表

```
[root@redis ~]# redis-cli 
127.0.0.1:6379> client list
id=11118 addr=127.0.0.1:42026 fd=5 name= age=3 idle=0 flags=N db=0 sub=0 psub=0 multi=-1 qbuf=0 qbuf-free=32768 obl=0 oll=0 omem=0 events=r cmd=client
```

- qbuf=0 qbuf-free=32768

- info clients

```
127.0.0.1:6379> info clients
# Clients
connected_clients:1
client_longest_output_list:0
client_biggest_input_buf:0
blocked_clients:0
```

- 设置 client_biggest_input_buf 最大输入缓冲区超过10M报警
- client_longest_output_list 最大输出缓冲列表 设置阈值
- 普通客户端输出缓冲区限制 默认不限制 client-output-buffer-limit normal 20mb 10mb 120
- 设置最大客户端数 config set maxclients 50 默认10000
- 超时 config set timeout 30 默认不超时
- client pause 暂停客户端
- monitor监控命令， 使用内存命令
- tcp-keepalive 保活监测
- tcp-backlog 队列大小 511 
- 监控connected_clients:1 不能超过 maxclients
- info stats

```
127.0.0.1:6379> info stats
# Stats
total_connections_received:11117
total_commands_processed:21857623
instantaneous_ops_per_sec:0
total_net_input_bytes:790271261
total_net_output_bytes:434083911
instantaneous_input_kbps:0.00
instantaneous_output_kbps:0.00
rejected_connections:0
sync_full:0
sync_partial_ok:0
sync_partial_err:0
expired_keys:1
evicted_keys:0
keyspace_hits:4993308
keyspace_misses:542205
pubsub_channels:0
pubsub_patterns:0
latest_fork_usec:212
migrate_cached_sockets:0
```

- 监控rejected_connections 拒绝客户端的个数
- 输出缓冲区爆了 禁用monitor命令 
- 慢查询 禁用hgetall 使用hscan替代 大于512才开始分页

```
echo 511 > /proc/sys/net/core/somaxconn
```
