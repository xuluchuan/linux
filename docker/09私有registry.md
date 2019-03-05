# 私有registry

## docker官方registry简介

- https协议
- docker-distribution
- ` yum -y install docker-registry`
- rpm -ql docker-distribution
- 配置文件：/etc/docker-distribution/registry/config.yml
- 镜像位置 /var/lib/registry
- 端口：5000
- systemctl start docker-distribution

### 打包

```
docker tag myweb:v0.3 192.168.135.5:5000/myweb:v0.3
docker image ls
docker push 192.168.135.5:5000/myweb:v0.3
```

- 报错 http 不是https
- 配置文件为"insecure-registres": ["192.168.135.5:5000"]
- systemctl restart docker
