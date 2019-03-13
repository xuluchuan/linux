### docker镜像

- 包括文件系统
- 分层构建，最底层bootfs(启动完后卸载)，上层rootfs，只读模式，最上层为读写层，联合挂载
- aufs 文件系统 统一联合叠加文件系统 overlayfs合并入内核
- ubuntu aufs centos7 dm overlayfs
- docker info :storage driver overlay2 后端：xfs
- docker run 后 本地拉，本地没有registry拉，默认dockerhub

### docker registry

- sponsor docker社区
- mirror 镜像
- vendor 红帽
- private 自建 harbor
- 二次配置镜像
- 包括repo和index
- 仓库名 用户名/仓库名
- 一个镜像有多个tag，一个tag属于一个镜像
- index 用户验证 检索接口
- 镜像开发制作后，推送到registry保存，部署到生产环境
- 配置文件，云原生，注入环境变量

### docker hub

- image repo 镜像仓库 个人账号
- automated build 自动构建 docker-file 或 docker commit手工构建
- webhooks github docker-file 推到dockerhub，automated构建
- org 组织
- docker pull repo:port/namespace/name:tag 
- quay.io
- namespace(组织，用户，或角色)

### docker commit手工制作镜像

- docker commit -p b1 制作镜像 

```
[root@docker ~]# docker start -ai b1
/ # mkdir /data/html/ -p
/ # echo "<h1>Hello World!</h1>" > /data/html/index.html
[root@docker ~]# docker commit -p b1
sha256:0348306138f321ec2632f3b401e6896b71a117383383e52c9e8d2f6ad2c63e82
[root@docker ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              0348306138f3        10 seconds ago      1.2MB
busybox             latest              3a093384ac30        13 days ago         1.2M
```
- docker tag ID xuluchuan/httpd:v0.1 加入标签
```
[root@docker ~]# docker tag 0348306138f3 xuluchuan/httpd:v0.1
[root@docker ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
xuluchuan/httpd     v0.1                0348306138f3        54 seconds ago      1.2MB
busybox             latest              3a093384ac30        13 days ago         1.2MB
```
- docker inspect b1 的Cmd是默认运行的命令

```
[root@docker ~]# docker inspect b1|grep -A 2 Cmd
            "Cmd": [
                "sh"
            ],
```

- docker commit -a "xuluchuan" -c 'CMD ["/bin/httpd","-f","-h","/data/html"]' -p b1 xuluchuan/httpd:v0.2 制作镜像同时修改启动命令
```
[root@docker ~]# docker commit -a "xuluchuan" -c 'CMD ["/bin/httpd","-f","-h","/data/html"]' -p b1 xuluchuan/httpd:v0.2
sha256:5635c62ae700d296f203faaa57222ad87e09a7ddd7b05138a7c68f7d91cfbcba
[root@docker ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
xuluchuan/httpd     v0.2                5635c62ae700        20 seconds ago      1.2MB
xuluchuan/httpd     v0.1                0348306138f3        2 minutes ago       1.2MB
busybox             latest              3a093384ac30        13 days ago         1.2MB
```
- docker run --name httpd1 -d xuluchuan/httpd:v0.2 启动镜像
```
[root@docker ~]# docker container run --name httpd1 -d xuluchuan/httpd:v0.2
2aee550e94ccc9de9a90d30f26477db2c325e0dbcff61e2d7e56b731c3761811
[root@docker ~]# docker container ls
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS               NAMES
2aee550e94cc        xuluchuan/httpd:v0.2   "/bin/httpd -f -h /d…"   30 seconds ago      Up 29 seconds                           httpd1
d9f364350b04        busybox:latest         "sh"                     About an hour ago   Up 6 minutes                            b1
[root@docker ~]# docker inspect httpd1|grep "IPAddress"
            "SecondaryIPAddresses": null,
            "IPAddress": "172.17.0.3",
                    "IPAddress": "172.17.0.3",
[root@docker ~]# curl 172.17.0.3
<h1>Hello World!</h1>
```
- docker login -u USER SERVER 登录服务器
- docker push xuluchuan/httpd 推送镜像

### 阿里云镜像

- docker login --username
- docker push aliURL/xuluchuan/httpd

```
docker login --username=xuluchuan19880106 registry.cn-hangzhou.aliyuncs.com
docker tag f2b74b3a48a5 registry.cn-hangzhou.aliyuncs.com/xuluchuan/nginx:v0.1
docker push registry.cn-hangzhou.aliyuncs.com/xuluchuan/nginx:v0.1
docker pull registry.cn-hangzhou.aliyuncs.com/xuluchuan/nginx:v0.1
```

### 导入导出

- docker save -o httpd.gz xuluchuan/httpd:v0.2 导出
- docker load -i httpd.gz 
```
[root@docker ~]# docker save -o httpd.gz xuluchuan/httpd:v0.1 xuluchuan/httpd:v0.2

[root@docker ~]# docker load -i httpd.gz 
2b6b22ac3fd5: Loading layer [==================================================>]   5.12kB/5.12kB
Loaded image: xuluchuan/httpd:v0.1
Loaded image: xuluchuan/httpd:v0.2
[root@docker ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
xuluchuan/httpd     v0.2                5635c62ae700        7 minutes ago       1.2MB
xuluchuan/httpd     v0.1                0348306138f3        9 minutes ago       1.2MB
busybox             latest              3a093384ac30        13 days ago         1.2MB
```
