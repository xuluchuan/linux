# docker命令
- 子命令
- 创建对象：docker (container) create
- docker version
- docker info 查看容器状态
- 存储驱动：overlay2

```
[root@docker ~]# docker version
Client:
 Version:           18.09.1
 API version:       1.39
 Go version:        go1.10.6
 Git commit:        4c52b90
 Built:             Wed Jan  9 19:35:01 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.1
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.6
  Git commit:       4c52b90
  Built:            Wed Jan  9 19:06:30 2019
  OS/Arch:          linux/amd64
  Experimental:     false
[root@docker ~]# docker info
Containers: 0
 Running: 0
 Paused: 0
 Stopped: 0
Images: 0
Server Version: 18.09.1
Storage Driver: overlay2
 Backing Filesystem: xfs
 Supports d_type: true
 Native Overlay Diff: true
Logging Driver: json-file
Cgroup Driver: cgroupfs
Plugins:
 Volume: local
 Network: bridge host macvlan null overlay
 Log: awslogs fluentd gcplogs gelf journald json-file local logentries splunk syslog
Swarm: inactive
Runtimes: runc
Default Runtime: runc
Init Binary: docker-init
containerd version: 9754871865f7fe2f4e74d43e2fc7ccd237edcbce
runc version: 96ec2177ae841256168fcf76954f7177af9446eb
init version: fec3683
Security Options:
 seccomp
  Profile: default
Kernel Version: 3.10.0-862.el7.x86_64
Operating System: CentOS Linux 7 (Core)
OSType: linux
Architecture: x86_64
CPUs: 6
Total Memory: 974.6MiB
Name: docker
ID: 2S4L:Q55J:VVII:VPU6:ZAOL:Z4BO:COOS:CUOR:LKHL:U4WZ:XFBM:SKRZ
Docker Root Dir: /var/lib/docker
Debug Mode (client): false
Debug Mode (server): false
Registry: https://index.docker.io/v1/
Labels:
Experimental: false
Insecure Registries:
 127.0.0.0/8
Registry Mirrors:
 https://registry.docker-cn.com/
Live Restore Enabled: false
Product License: Community Engine
```

### docker常见操作

- docker system df 查看系统使用
- 生产环境：私有registry，自己制作镜像
- docker search 搜索镜像 alphine 测试最小版

```
[root@docker ~]# docker search nginx
NAME                                                   DESCRIPTION                                     STARS               OFFICIAL            AUTOMATED
nginx                                                  Official build of Nginx.                        10718               [OK]                
jwilder/nginx-proxy                                    Automated Nginx reverse proxy for docker con…   1501                                    [OK]
richarvey/nginx-php-fpm                                Container running Nginx + PHP-FPM capable of…   673                                     [OK]
jrcs/letsencrypt-nginx-proxy-companion                 LetsEncrypt container to use with nginx as p…   466                                     [OK]
webdevops/php-nginx                                    Nginx with PHP-FPM                              120                                     [OK]
kitematic/hello-world-nginx                            A light-weight nginx container that demonstr…   118                                     
zabbix/zabbix-web-nginx-mysql                          Zabbix frontend based on Nginx web-server wi…   85                                      [OK]
bitnami/nginx                                          Bitnami nginx Docker Image                      59                                      [OK]
linuxserver/nginx                                      An Nginx container, brought to you by LinuxS…   49                                      
1and1internet/ubuntu-16-nginx-php-phpmyadmin-mysql-5   ubuntu-16-nginx-php-phpmyadmin-mysql-5          48                                      [OK]
tobi312/rpi-nginx                                      NGINX on Raspberry Pi / armhf                   23                                      [OK]
nginx/nginx-ingress                                    NGINX Ingress Controller for Kubernetes         15                                      
blacklabelops/nginx                                    Dockerized Nginx Reverse Proxy Server.          12                                      [OK]
wodby/drupal-nginx                                     Nginx for Drupal container image                11                                      [OK]
centos/nginx-18-centos7                                Platform for running nginx 1.8 or building n…   10                                      
nginxdemos/hello                                       NGINX webserver that serves a simple page co…   9                                       [OK]
webdevops/nginx                                        Nginx container                                 8                                       [OK]
centos/nginx-112-centos7                               Platform for running nginx 1.12 or building …   6                                       
1science/nginx                                         Nginx Docker images that include Consul Temp…   4                                       [OK]
travix/nginx                                           NGinx reverse proxy                             2                                       [OK]
mailu/nginx                                            Mailu nginx frontend                            2                                       [OK]
pebbletech/nginx-proxy                                 nginx-proxy sets up a container running ngin…   2                                       [OK]
toccoag/openshift-nginx                                Nginx reverse proxy for Nice running on same…   1                                       [OK]
ansibleplaybookbundle/nginx-apb                        An APB to deploy NGINX                          0                                       [OK]
wodby/nginx                                            Generic nginx                                   0                                       [OK]
```

- 去docker hub搜索 https://hub.docker.com
- docker image pull 下载镜像 nginx:1.14-alphine busybox

```
[root@docker ~]# docker image pull nginx:1.14.2-alpine
1.14.2-alpine: Pulling from library/nginx
cd784148e348: Pull complete 
12b08f7ef616: Pull complete 
65071a4e699c: Pull complete 
9936647427be: Pull complete 
Digest: sha256:e3f77f7f4a6bb5e7820e013fa60b96602b34f5704e796cfd94b561ae73adcf96
Status: Downloaded newer image for nginx:1.14.2-alpine
```

- docker image ls 列出镜像

```
[root@docker ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nginx               1.14.2-alpine       c5b6f731fbc0        3 weeks ago         17.7MB
```

- busybox 模拟linux

```
[root@docker ~]# docker image pull busybox:latest
latest: Pulling from library/busybox
57c14dd66db0: Pull complete 
Digest: sha256:7964ad52e396a6e045c39b5a44438424ac52e12e4d5a25d94895f2058cb863a0
Status: Downloaded newer image for busybox:latest
```

- docker image rm 删除镜像

```
[root@docker ~]# docker image rm c5b6f731fbc0
Untagged: nginx:1.14.2-alpine
Untagged: nginx@sha256:e3f77f7f4a6bb5e7820e013fa60b96602b34f5704e796cfd94b561ae73adcf96
Deleted: sha256:c5b6f731fbc07a20c352256b94891c178e687910dd3fd5318c7bb0b6f6962780
Deleted: sha256:c17dfbe3f6d0fa19e6f3c9c7244d97674397debda3b5012bc0426f0fcbbefe10
Deleted: sha256:7ba3500e8911126c3d04dfedf89021fc27635cbf4524ade18c13aef930103f3c
Deleted: sha256:bd23dab8e80522b6bf9d77b62f3e94778cbb1f3490408da2a094cf53f62dd90e
Deleted: sha256:7bff100f35cb359a368537bb07829b055fe8e0b1cb01085a3a628ae9c187c7b8
[root@docker ~]# docker image pull nginx:1.14.2-alpine
1.14.2-alpine: Pulling from library/nginx
cd784148e348: Pull complete 
12b08f7ef616: Pull complete 
65071a4e699c: Pull complete 
9936647427be: Pull complete 
Digest: sha256:e3f77f7f4a6bb5e7820e013fa60b96602b34f5704e796cfd94b561ae73adcf96
Status: Downloaded newer image for nginx:1.14.2-alpine

[root@docker ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```

- docker container create 创建容器
- docker container start 启动 stop 结束 kill 强行停止 run 创建并启动 rm 删除 pause 暂停 unpause 取消暂停 top 查看 ls 显示正在运行的 ls -a 显示全部

- docker network ls 查看网络，默认bridge

```
[root@docker ~]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
71803242b3d0        bridge              bridge              local
f66aba2551e1        host                host                local
58abf5c4e909        none                null                local
```

- docker container run --name b1 -it busybox:last

```
[root@docker ~]# docker container run --name b1 -it busybox:latest
/ # ls
bin   dev   etc   home  proc  root  sys   tmp   usr   var
/ # 
/ # ps
PID   USER     TIME  COMMAND
    1 root      0:00 sh
    7 root      0:00 ps
/ # exit

```

- docker inspect b1 查看 b1的ip

```
[root@docker ~]# docker inspect b1
[
    {
        "Id": "d9f364350b04ad0d2bf0f3182038b8463073b04c6cc7067ef58a1b6818f4a7bc",
        "Created": "2019-01-14T14:24:22.20281276Z",
        "Path": "sh",
        "Args": [],
        "State": {
            "Status": "exited",
            "Running": false,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 0,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2019-01-14T14:24:22.626137706Z",
            "FinishedAt": "2019-01-14T14:25:07.595730183Z"
        },
        "Image": "sha256:3a093384ac306cbac30b67f1585e12b30ab1a899374dabc3170b9bca246f1444",
        "ResolvConfPath": "/var/lib/docker/containers/d9f364350b04ad0d2bf0f3182038b8463073b04c6cc7067ef58a1b6818f4a7bc/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/d9f364350b04ad0d2bf0f3182038b8463073b04c6cc7067ef58a1b6818f4a7bc/hostname",
        "HostsPath": "/var/lib/docker/containers/d9f364350b04ad0d2bf0f3182038b8463073b04c6cc7067ef58a1b6818f4a7bc/hosts",
        "LogPath": "/var/lib/docker/containers/d9f364350b04ad0d2bf0f3182038b8463073b04c6cc7067ef58a1b6818f4a7bc/d9f364350b04ad0d2bf0f3182038b8463073b04c6cc7067ef58a1b6818f4a7bc-json.log",
        "Name": "/b1",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "shareable",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DiskQuota": 0,
            "KernelMemory": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": 0,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/3e224969accec2686b5c7d51c23fac60bbe0d8544ba7f45d3ea90d6daca48366-init/diff:/var/lib/docker/overlay2/9336f492d5b59ba269f7e3805271326f1934c7773b78903df6aaba4f7196f8e9/diff",
                "MergedDir": "/var/lib/docker/overlay2/3e224969accec2686b5c7d51c23fac60bbe0d8544ba7f45d3ea90d6daca48366/merged",
                "UpperDir": "/var/lib/docker/overlay2/3e224969accec2686b5c7d51c23fac60bbe0d8544ba7f45d3ea90d6daca48366/diff",
                "WorkDir": "/var/lib/docker/overlay2/3e224969accec2686b5c7d51c23fac60bbe0d8544ba7f45d3ea90d6daca48366/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "d9f364350b04",
            "Domainname": "",
            "User": "",
            "AttachStdin": true,
            "AttachStdout": true,
            "AttachStderr": true,
            "Tty": true,
            "OpenStdin": true,
            "StdinOnce": true,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
            ],
            "Cmd": [
                "sh"
            ],
            "ArgsEscaped": true,
            "Image": "busybox:latest",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {}
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "3030d43a19678b50c61e57fe738b73ecb1604bda78c68fcd531f51bf69229df3",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {},
            "SandboxKey": "/var/run/docker/netns/3030d43a1967",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "",
            "Gateway": "",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "",
            "IPPrefixLen": 0,
            "IPv6Gateway": "",
            "MacAddress": "",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "71803242b3d029c29fea0580f910021fcbceccbfe19598e1d2482c9877305f1f",
                    "EndpointID": "",
                    "Gateway": "",
                    "IPAddress": "",
                    "IPPrefixLen": 0,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "",
                    "DriverOpts": null
                }
            }
        }
    }
]
```

- docker container ls (ls -a) 查看容器状态

```
[root@docker ~]# docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[root@docker ~]# docker container ls -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                          PORTS               NAMES
d9f364350b04        busybox:latest      "sh"                2 minutes ago       Exited (0) About a minute ago                       b1
```

- docker start -ai b1 再启动

```
[root@docker ~]# docker start -ai b1
/ # ps
PID   USER     TIME  COMMAND
    1 root      0:00 sh
    6 root      0:00 ps
/ # ls
bin   dev   etc   home  proc  root  sys   tmp   usr   var
/ # exit
```

- docker container run --name nginx1 -d nginx:1.14-alpine 启动后台

```
[root@docker ~]# docker container run --name nginx1 -d nginx:1.14.2-alpine
1e32b80729c2d5b17b5c8ea1d59e06b9853538b1496c80cdf51708ce65178345
[root@docker ~]# docker inspect nginx1
[
    {
        "Id": "1e32b80729c2d5b17b5c8ea1d59e06b9853538b1496c80cdf51708ce65178345",
        "Created": "2019-01-14T14:29:35.518441133Z",
        "Path": "nginx",
        "Args": [
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 2824,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2019-01-14T14:29:35.848913231Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:c5b6f731fbc07a20c352256b94891c178e687910dd3fd5318c7bb0b6f6962780",
        "ResolvConfPath": "/var/lib/docker/containers/1e32b80729c2d5b17b5c8ea1d59e06b9853538b1496c80cdf51708ce65178345/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/1e32b80729c2d5b17b5c8ea1d59e06b9853538b1496c80cdf51708ce65178345/hostname",
        "HostsPath": "/var/lib/docker/containers/1e32b80729c2d5b17b5c8ea1d59e06b9853538b1496c80cdf51708ce65178345/hosts",
        "LogPath": "/var/lib/docker/containers/1e32b80729c2d5b17b5c8ea1d59e06b9853538b1496c80cdf51708ce65178345/1e32b80729c2d5b17b5c8ea1d59e06b9853538b1496c80cdf51708ce65178345-json.log",
        "Name": "/nginx1",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {},
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "CapAdd": null,
            "CapDrop": null,
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "shareable",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "ConsoleSize": [
                0,
                0
            ],
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": null,
            "BlkioDeviceWriteBps": null,
            "BlkioDeviceReadIOps": null,
            "BlkioDeviceWriteIOps": null,
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DiskQuota": 0,
            "KernelMemory": 0,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": false,
            "PidsLimit": 0,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/e78bd825821aec9f307b7d3295ccdd8a55334029a1ba272293851cdeb3213eb4-init/diff:/var/lib/docker/overlay2/c4914d16dac1cfd2452617fc42756f9598a119c245b3e4a6a659ea9fdf8ffe3f/diff:/var/lib/docker/overlay2/601261b5969ad9eb3a766d1fa2e7de0a8770314aad0c5d3bf5ee977ca90e5793/diff:/var/lib/docker/overlay2/29b8cb0bcc133fbdb77938c84316d77da22cd052bac6907300ce8495039fb972/diff:/var/lib/docker/overlay2/b3c138765682afa9a438ff29ba69136aa7e484d1d4379d24a7e2e36cca75e6a3/diff",
                "MergedDir": "/var/lib/docker/overlay2/e78bd825821aec9f307b7d3295ccdd8a55334029a1ba272293851cdeb3213eb4/merged",
                "UpperDir": "/var/lib/docker/overlay2/e78bd825821aec9f307b7d3295ccdd8a55334029a1ba272293851cdeb3213eb4/diff",
                "WorkDir": "/var/lib/docker/overlay2/e78bd825821aec9f307b7d3295ccdd8a55334029a1ba272293851cdeb3213eb4/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "1e32b80729c2",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.14.2"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "ArgsEscaped": true,
            "Image": "nginx:1.14.2-alpine",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": null,
            "OnBuild": null,
            "Labels": {
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
            },
            "StopSignal": "SIGTERM"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "f961a65efddd9a40c428797be5ab8ddec6623634708ec866d2489328b0e73c27",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": null
            },
            "SandboxKey": "/var/run/docker/netns/f961a65efddd",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "83705d35e55f45ef2321458ed48689395ce77fe75c2e6394469dfe636e995c31",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "71803242b3d029c29fea0580f910021fcbceccbfe19598e1d2482c9877305f1f",
                    "EndpointID": "83705d35e55f45ef2321458ed48689395ce77fe75c2e6394469dfe636e995c31",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
[root@docker ~]# docker container ls
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
1e32b80729c2        nginx:1.14.2-alpine   "nginx -g 'daemon of…"   55 seconds ago      Up 54 seconds       80/tcp              nginx1

```

- docker container exec 容器内执行命令
- docker container exec -it nginx1 /bin/sh

```
[root@docker ~]# docker container exec -it nginx1 /bin/sh
/ # ls
bin    dev    etc    home   lib    media  mnt    proc   root   run    sbin   srv    sys    tmp    usr    var
/ # ps
PID   USER     TIME  COMMAND
    1 root      0:00 nginx: master process nginx -g daemon off;
    7 nginx     0:00 nginx: worker process
    8 root      0:00 /bin/sh
   14 root      0:00 ps
/ # top
Mem: 834256K used, 163724K free, 7892K shrd, 2076K buff, 508044K cached
CPU:   0% usr   1% sys   0% nic  98% idle   0% io   0% irq   0% sirq
Load average: 0.00 0.01 0.05 2/217 15
  PID  PPID USER     STAT   VSZ %VSZ CPU %CPU COMMAND
    7     1 nginx    S    14252   1%   3   0% nginx: worker process
    1     0 root     S    13804   1%   4   0% nginx: master process nginx -g daemon off;
    8     0 root     S     1580   0%   1   0% /bin/sh
   15     8 root     R     1512   0%   4   0% top
/ # exit
```

- docker container logs 查看日志

```
[root@docker ~]# curl 172.17.0.2
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
[root@docker ~]# docker container logs nginx1
172.17.0.1 - - [14/Jan/2019:14:32:33 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/7.29.0" "-"

[root@docker ~]# docker container stop nginx1
nginx1
[root@docker ~]# docker container ls
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
[root@docker ~]# docker container ls -a
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS                     PORTS               NAMES
1e32b80729c2        nginx:1.14.2-alpine   "nginx -g 'daemon of…"   4 minutes ago       Exited (0) 7 seconds ago                       nginx1
d9f364350b04        busybox:latest        "sh"                     9 minutes ago       Exited (0) 6 minutes ago                       b1

[root@docker ~]# docker container start nginx1
nginx1
[root@docker ~]# docker container ls 
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS               NAMES
1e32b80729c2        nginx:1.14.2-alpine   "nginx -g 'daemon of…"   5 minutes ago       Up 4 seconds        80/tcp              nginx1

[root@docker ~]# docker container stop nginx1
nginx1

[root@docker ~]# docker container rm nginx1
nginx1

[root@docker ~]# docker container ls -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
d9f364350b04        busybox:latest      "sh"                11 minutes ago      Exited (0) 7 minutes ago                       b1
[root@docker ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
busybox             latest              3a093384ac30        13 days ago         1.2MB
nginx               1.14.2-alpine       c5b6f731fbc0        3 weeks ago         17.7MB

[root@docker ~]# docker image rm c5b6f731fbc0
Untagged: nginx:1.14.2-alpine
Untagged: nginx@sha256:e3f77f7f4a6bb5e7820e013fa60b96602b34f5704e796cfd94b561ae73adcf96
Deleted: sha256:c5b6f731fbc07a20c352256b94891c178e687910dd3fd5318c7bb0b6f6962780
Deleted: sha256:c17dfbe3f6d0fa19e6f3c9c7244d97674397debda3b5012bc0426f0fcbbefe10
Deleted: sha256:7ba3500e8911126c3d04dfedf89021fc27635cbf4524ade18c13aef930103f3c
Deleted: sha256:bd23dab8e80522b6bf9d77b62f3e94778cbb1f3490408da2a094cf53f62dd90e
Deleted: sha256:7bff100f35cb359a368537bb07829b055fe8e0b1cb01085a3a628ae9c187c7b8
[root@docker ~]# docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
busybox             latest              3a093384ac30        13 days ago         1.2MB
```


### docker状态

- created stopped running paused deleted