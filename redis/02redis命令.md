### api的理解和使用

#### 全局命令

- `keys *` 查看所有键
- `set hello world` 字符串类型的键值对

```
[root@redis ~]# redis-cli 
127.0.0.1:6379> ping
PONG
127.0.0.1:6379> keys *
(empty list or set)
127.0.0.1:6379> set hello world
OK
127.0.0.1:6379> set java jedis
OK
127.0.0.1:6379> set python redis-py
OK
127.0.0.1:6379> keys *
1) "python"
2) "hello"
3) "java"
```

- dbsize 查看总键值对个数，时间复杂度低
- keys \* 遍历，时间复杂度高，生产环境禁止使用

```
127.0.0.1:6379> rpush mylist a b c d e f g
(integer) 7
127.0.0.1:6379> keys *
1) "python"
2) "hello"
3) "mylist"
4) "java"
127.0.0.1:6379> dbsize
(integer) 4
```

- exists KEY 是否存在一个键 存在返回1 不存在返回0
- del KEY 删除键 返回删除的个数 不存在返回0

```
127.0.0.1:6379> del python
(integer) 1
127.0.0.1:6379> del hello mylist
(integer) 2
127.0.0.1:6379> exists python
(integer) 0
```

- expire KEY SECONDS 设置键的过期时间 成功为1，不成功为0
- ttl KEY 查询过期时间 -1 没有设置 -2 键不存在

```
127.0.0.1:6379> ttl java
(integer) -1
127.0.0.1:6379> expire java 3
(integer) 1
127.0.0.1:6379> ttl java
(integer) 1
127.0.0.1:6379> ttl java
(integer) -2
```

- type 查看数据类型

```
127.0.0.1:6379> type no-exist
none
127.0.0.1:6379> set hello world
OK
127.0.0.1:6379> type hello
string
127.0.0.1:6379> rpush mylist a b c d
(integer) 4
127.0.0.1:6379> type mylist
list
```

- object encoding查看数据结构的内部编码

```
127.0.0.1:6379> object encoding mylist
"quicklist"
127.0.0.1:6379> object encoding hello
"embstr"
```

### 字符串

- 设置 set key value (ex seconds)|(px milliseconds) (nx)|(xx)
- ex px 过期时间
- 默认键不存在添加，键存在更新
- nx 键不存在才可添加成功 只添加 setnx 
- xx 键存在才可添加成功 只更新 setxx
- get key 获取值 不存在返回 nil
- mset key value key value 批量设置
- mget key key 批量获取
- 批量操作有助于客户端节省网络时间
- incr 自增计数
- append 追加字符串
- strlen 字符串长度
- getset 设置值的同时返回原来的值
- setrange 截取
- getrange 截取

#### 字符串使用场景

- 1.redis缓存mysql的热数据，加速读写，减少mysql压力
- 业务名:对象名:id:属性
- 字符串序列化
- 添加过期时间 1个小时
- 2.计数 incr
- 3.session管理器
- 4.限速 每秒钟不能发送太多次验证码

### 哈希

- 设置 hset key field value 成功返回1 失败返回0
- hsetnx 键不存在才可添加成功
- 获取 hget key field 
- 删除 field   hdel key field 
- 计数 hlen key
- 批量设置 hmset key field value field value 
- 批量查询 hmget key field field
- 是否存在field hexists key field 
- 获取field hkeys key
- 获取value hvals key 
- 获取field-value hgetall key 
- hstrlen 字符串长度
- hincrby key filed 自增
- value大于64字节，field超过512，内部编码转化
- hash存储用户信息比字符串序列化存储要方便
- hash是稀疏的
- 使用场景：redis缓存mysql的热数据

```shell
127.0.0.1:6379> type user:1
hash
127.0.0.1:6379> hkeys user:1
1) "name"
2) "age"
127.0.0.1:6379> hmget user:1 name age
1) "tom"
2) "13"
```

### 列表

- 有序可重复
- 添加：rpush lpush linsert
- 查：lrange lindex llen
- 删除：lpop rpop lrem ltrim
- 修改：lset
- 阻塞：blpop brpop
- rpush 从右添加 rpush key value1 value2
- lrange key start end 查询 0 -1 所有 包前包后
- lpush 左侧插入
- linsert 找到元素后添加 linsert listkey before|after b java
- lindex key index 指定索引的元素
- llen 获取长度
- lpop 左侧弹出
- rpop 右侧弹出
- lrem key count value 删除指定元素 count=0 所有 count>0 从左count个，否则从右count个
- ltrim key start end 只保留索引内的元素
- lset key index newValue 修改指定索引
- brpop key1 key2 timeout  timeout=0为永久

### 列表使用场景

- lpush + brpop 消息队列 生产者lpush插入，多个消费者brpop抢列表尾部的元素
- 分页展示文章列表
- lpush + brpop 消息队列
- lpush + rpop 队列
- lpush + lpop 栈
- lpush + ltrim 有限集合
- php-resque 任务消息队列

### 集合

- 无序不重复
- sadd key element 增加
- sadd myset a b c 
- srem key element 删除
- scard myset 查询元素个数
- sismember myset c 查询元素是否存在
- srandmember key count 随机返回
- spop key 随机弹出
- smembers key 获取所有元素
- sinter 交集
- sunion 并集
- sdiff 差集
- sinterstore 保存

#### 集合使用场景

- 1.sadd标签
- 用户和标签放在同一个事务下执行
- 2.spop/srandmember 随机数，抽奖
- 3.sadd标签 + sinter 社交需求

### 有序集合

- 有序，不可重复
- 使用score来排序
- zadd key score member [score member]
- zcard 成员个数
- zscore 分数
- zrank key member 排名
- zrem 删除
- zincrby key increment member 增加score
- zrange zrevrange 查看前几名 with scores带分数
- zrangebyscore 根据分数查看
- zrangebyrank 根据排名查看
- zcount 返回成员个数
- zremrangebyrank 删除排名成员
- zremrangebyscore 删除分数

#### 使用场景

- 排行榜系统

### 键管理

- rename key newkey
- renamenx 不存在才覆盖
- randomkey 随机返回一个键
- persist 将键的过期时间清除
- set会导致过期时间失效
- setex 一次设置

### 键迁移

- 1.dump + restore
- dump key 
- restore key ttl value
- 2.migrate
- migrate 127.0.0.1 6380 key1 0 5000 replace 存在则覆盖
- migrate 127.0.0.1 6380 ""(多个键) 0(0号数据库) 5000(超时时间) keys key1 key2 
- 可以多个键，原子性 

### 遍历键

- keys \* 全量遍历
- \* 所有 \. 任意一个 [1-10] 范围内任意一个 
- `redis-cli keys video* | xargs redis-cli del` 删除所有的video开头的键
- keys 会阻塞 使用scan
- scan hscan sscan zscan 
- cursor游标
- 新增键可以没有遍历到

### 数据库管理

- databasese 16 0-15号数据库
- select 0-15 切换 只建议使用0号数据库 多数据库用端口区分
- flushdb/flushall 清空数据库

```
Redis提供了非常简单且有效的方法，直接在配置文件中设置禁用这些命令。设置非常简单，如下

rename-command FLUSHALL ""
rename-command FLUSHDB ""
rename-command KEYS ""
```