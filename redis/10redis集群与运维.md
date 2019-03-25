## redis sentinel

### 高可用

- 监控其他节点
- 通知
- 主节点故障转移
- 配置提供者

### 架构

- 三个sentinel 一个master 两个salve
- 26379
- `sentinel monitor mymaster 127.0.0.1 6379 2`


## redis cluster

- 准备节点
- 节点握手
- 分配槽
- 至少6个节点


## 缓存

- 剔除 超时 主动更新
- 无底洞问题：批量操作
- 布隆过滤器 缓存穿透问题 缓存空对象
- 雪崩优化：高可用
- 热点key重建优化：用不过期

## 运维

- vm.overcommit_memory=1 小内存也可用
- 内存分配：maxmemory保证系统20%可用内存，aof重写和bgsave要集中管理
- 尽可能不用swap

```
如果 > 2.6.32-303.el6 RHEL/CentOS， vm.swapniess=1， 否则vm.swapniess=0， 从而实现如下
两个目标：
·物理内存充足时候， 使Redis足够快。
·物理内存不足时候， 避免Redis死掉（如果当前Redis为高可用， 死掉比
阻塞更好） 。
```

- 关闭THP
- 文件描述符 65535
- backlog 511
- 设置密码 监听内网 换端口 不用root启动
- rename command
- 监控bigkey 4.0 lazy delete free 
- elk packetbeat 监控tcp 统计热点key 设置不过期
