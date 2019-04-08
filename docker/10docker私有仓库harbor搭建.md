Harbor 详细介绍

https://blog.51cto.com/13043516/2287267
Harbor安装指南
Harbor官网配置CA认证
Kubernetes Harbor安装教程
Centos7安装Docker镜像仓库Harbor1.5.3

1、容器应用的开发和运行离不开可靠的镜像管理。从安全和效率等方面考虑，部署在私有环境内的 Registry 是非常必要的。

2、Harbor 是由 VMware 公司中国团队为企业用户设计的 Registry server 开源项目，包括了权限管理(RBAC)、LDAP、审计、管理界面、自我注册、HA 等企业必需的功能，同时针对中国用户的特点，设计镜像复制和中文支持等功能，欢迎使用和反馈意见。

3、作为一个企业级私有 Registry 服务器，Harbor 提供了更好的性能和安全。提升用户使用 Registry 构建和运行环境传输镜像的效率。Harbor 支持安装在多个 Registry 节点的镜像资源复制，镜像全部保存在私有 Registry 中， 确保数据和知识产权在公司内部网络中管控。另外，Harbor 也提供了高级的安全特性，诸如用户管理，访问控制和活动审计等。

1）基于角色的访问控制
用户与 Docker 镜像仓库通过“项目”进行组织管理，一个用户可以对多个镜像仓库在同一命名空间（project）里有不同的权限。

2）镜像复制
镜像可以在多个 Registry 实例中复制（同步）。尤其适合于负载均衡，高可用，混合云和多云的场景。

4）AD/LDAP 支持
Harbor 可以集成企业内部已有的 AD/LDAP，用于鉴权认证管理。

5）审计管理
所有针对镜像仓库的操作都可以被记录追溯，用于审计管理。

6）国际化
已拥有英文、中文、德文、日文和俄文的本地化版本。更多的语言将会添加进来。

7）RESTful API
RESTful API 提供给管理员对于 Harbor 更多的操控, 使得与其它管理软件集成变得更容易。

8）部署简单
提供在线和离线两种安装工具， 也可以安装到 vSphere 平台(OVA 方式)虚拟设备

Harbor 架构介绍
Harbor在架构上主要由五个组件构成：
1、Proxy：
Harbor的registry, UI, token等服务，通过一个前置的反向代理统一接收浏览器、Docker客户端的请求，并将请求转发给后端不同的服务。

2、Registry：
负责储存Docker镜像，并处理docker push/pull 命令。由于我们要对用户进行访问控制，即不同用户对Docker image有不同的读写权限，Registry会指向一个token服务，强制用户的每次docker pull/push请求都要携带一个合法的token, Registry会通过公钥对token 进行解密验证。

3、Core services：
这是Harbor的核心功能，主要提供以下服务：

1）UI：提供图形化界面，帮助用户管理registry上的镜像（image）, 并对用户进行授权。

2）webhook：为了及时获取registry 上image状态变化的情况， 在Registry上配置webhook，把状态变化传递给UI模块。

3）token 服务：负责根据用户权限给每个docker push/pull命令签发token. Docker 客户端向Regiøstry服务发起的请求,如果不包含token，会被重定向到这里，获得token后再重新向Registry进行请求。

4、Database：
为core services提供数据库服务，负责储存用户权限、审计日志、Docker image分组信息等数据。

5、Log collector：
为了帮助监控Harbor运行，负责收集其他组件的log，供日后进行分析。
各个组件之间的关系如下图所示：
Centos7安装Docker镜像仓库Harbor1.5.3

实验环境：
系统版本：centos7x3.10.0-514.el7.x86_64

Docker版本：1.13.1（yum安装）

harbor版本：harbor-offline-installer-v1.5.3.tgz（离线版）

注：由于Harbor是基于Docker Registry V2版本，所以就要求Docker版本不小于1.10.0，Docker-compose版本不小于1.6.0。

关闭防火墙并禁止开机自启

systemctl stop firewalld.service
systemctl disable firewalld

关闭selinux

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

修改主机名

vi /etc/hostname
harbor.123.com
Centos7安装Docker镜像仓库Harbor1.5.3

域名绑定IP

vi /etc/hosts
192.168.152.170 harbor.123.com
Centos7安装Docker镜像仓库Harbor1.5.3

重启 reboot

安装harbor（IP：192.168.152.170）
1、安装harbor依赖环境
1）安装docker
yum -y install docker

注：建议安装最新稳定版docker！

2）安装docker-compose
yum -y install docker-compose
Centos7安装Docker镜像仓库Harbor1.5.3 
注：如果安装不上就先安装epel-release源，然后安装docker-compose！

3）依赖软件安装
yum install -y yum-utils device-mapper-persistent-data lvm2
Centos7安装Docker镜像仓库Harbor1.5.3

2、下载离线安装包harbor-offline-installer-v1.5.3.tgz
1）使用下载命令wget或者aria2c下载harbor
wget https://storage.googleapis.com/harbor-releases/harbor-offline-installer-v1.5.3.tgz
Centos7安装Docker镜像仓库Harbor1.5.3 
注：因为我这里网络不太好所以使用aria2c下载的，以上截图表示下载成功！

2）解压harbor到本地
tar zxf harbor-offline-installer-v1.5.3.tgz
Centos7安装Docker镜像仓库Harbor1.5.3

3）将解压目录移动到/data目录
//创建harbor数据存储目录

mkdir /data
Centos7安装Docker镜像仓库Harbor1.5.3 
注：可能有的童鞋不太理解这一步的意思，简单来说就是harbor默认的数据存储目录就是/data目录，所以我先创建好，并将harbor解压目录移动到这里，当然如果不创建，后期启动harbor时也会自动创建的！

//移动harbor解压目录

mv harbor /data/
Centos7安装Docker镜像仓库Harbor1.5.3
注：这一步操作是为了方便管理和防止误删除（可做可不做）！

//创建CA证书存放目录

mkdir /data/cert
Centos7安装Docker镜像仓库Harbor1.5.3 
注：可以在这个目录里创建证书！

创建CA证书
1、创建CA的证书
//进入存放证书目录

cd /data/cert/

//创建自己的CA证书

openssl req -newkey rsa:4096 -nodes -sha256 -keyout ca.key -x509 -days 365 -out ca.crt
Centos7安装Docker镜像仓库Harbor1.5.3
注：因为出于安全的考虑，所以强烈建议搭建基于https的harbor，那么就需要添加ca证书！

2、生成CA证书签名请求
openssl req -newkey rsa:4096 -nodes -sha256 -keyout harbor.123.com.key -out harbor.123.com.csr
Centos7安装Docker镜像仓库Harbor1.5.3

3、生成注册主机的证书
方式一：使用域名生成注册主机证书
openssl x509 -req -days 365 -in harbor.123.com.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out harbor.123.com.crt
Centos7安装Docker镜像仓库Harbor1.5.3 
注：以上这步操作是和wangfeiyu.com.csr在同一目录操作的，如果不在同一目录，需要写绝对路径，否则可能会报错！

方式二：使用IP生成注册主机证书
//echo subjectAltName = IP：192.168.152.170 > extfile.cnf

//openssl x509 -req -days 365 -in wangfeiyu.com.csr -CA ca.crt -CAkey

ca.key -CAcreateserial -extfile extfile.cnf -out harbor.123.com.crt

注：执行以上两条命令即可实现IP注册主机证书！

4、编辑harbor配置文件
编辑harbor.cfg文件
vi /data/harbor/harbor.cfg

#hostname设置访问地址。可以使用ip、域名、主机名，不可以设置为127.0.0.1或localhost。(如果部署的是备份库，填写ip而不是域名，否则会导致仓库管理连接失败，host无法识别原因不明)
hostname = harbor.123.com
#访问协议。默认是http，如果搭建https的仓库就改为https。
ui_url_protocol = https
#可选的https证书配置地址 
ssl_cert = /root/cert/bakreg.cn.crt 
ssl_cert_key = /root/cert/bakreg.cn.key
#用于在复制策略中加密或解密远程注册表的密码的密钥路径。secretkey_path不需要修改。如果必须修改它，你需要在/root/harbor/docker-compose.yml中手动调整路径，因为它们是硬编码。
secretkey_path = /data
#邮件设置，发送重置密码邮件时使用 
#email_identity作为用户名
email_identity = 
email_server = 邮箱的smtp服务器域名
email_server_port = 25
email_username = 
email_password = 
email_from = 
email_ssl = false
email_insecure = false
#管理员admin的登录密码。默认是Harbor12345
harbor_admin_password = Harbor12345
#认证方式。默认是db_auth，支持多种认证方式，如数据库认证（db_auth）、LADP（ldap_auth）。
auth_mode = db_auth
#LDAP认证时配置项（这项可以登录后配置也可以）。
ldap_url = # LDAP URL
ldap_searchdn = # LDAP 搜索DN
ldap_search_pwd = # LDAP 搜索DN的密码
ldap_basedn = # LDAP 基础DN
ldap_filter = # LDAP 过滤器
ldap_uid = # LDAP 用户uid的属性
ldap_scope = 2
ldap_timeout = 5
#是否开启注册。on开启，off关闭。
self_registration = off
#Token有效时间。默认30分钟。
token_expiration = 30
#标记用户创建项目权限控制。默认是everyone（允许所有人创建），也可以设置为adminonly（只能管理员才能创建）
project_creation_restriction = everyone

Centos7安装Docker镜像仓库Harbor1.5.3
注：暂时先更改这几行即可启动，其他功能按照需求更改！

5、启动harbor服务
1）启动docker并设置开机自启
systemctl start docker
systemctl enable docker

2）进入harbor解压目录
cd /data/harbor/

3）安装harbor
./install.sh
Centos7安装Docker镜像仓库Harbor1.5.3
Centos7安装Docker镜像仓库Harbor1.5.3Centos7安装Docker镜像仓库Harbor1.5.3
Centos7安装Docker镜像仓库Harbor1.5.3
注：以上截图说明harbor的https协议加密成功！

3）harbor的启动和关闭方式
//关闭harbor服务（先进入harbor目录）

docker-compose stop
Centos7安装Docker镜像仓库Harbor1.5.3

//开启harbor服务（先进入harbor目录）

docker-compose up -d
Centos7安装Docker镜像仓库Harbor1.5.3

6、验证harbor服务是否正常运行（建议使用Firefox浏览器测试）
1）访问地址：https://harbor.123.com
Centos7安装Docker镜像仓库Harbor1.5.3
注：有童鞋可能不理解为啥不用IP地址访问，因为我们是针对域名做的https证书，所以只能使用域名访问才能使用自签的证书！但是问题又来了，为啥浏览器会这样呢？原因是windows没有针对这个域名做域名解析，怎么才能让他访问到呢？

设置方式：（windows系统）

//打开windows路径C:\Windows\System32\drivers\etc
Centos7安装Docker镜像仓库Harbor1.5.3

//点击这个特殊的hosts文件，并用记事本方式打开
Centos7安装Docker镜像仓库Harbor1.5.3
注：将harbor服务器的域名和IP记录到windows系统中，即可实现域名访问网页！

2）再访问这个地址：https://harbor.123.com
Centos7安装Docker镜像仓库Harbor1.5.3
注：以上截图访问方式使用的是https加密访问但是需要我们将证书导入浏览器才行！

导入方式：
//点击高级
Centos7安装Docker镜像仓库Harbor1.5.3

//点击添加列外
Centos7安装Docker镜像仓库Harbor1.5.3

//点击确认安全列外
Centos7安装Docker镜像仓库Harbor1.5.3 
注：以上截图已经可以访问到网页，说明nginx加密成功或者证书导入成功！其他的浏览器导入证书方式不一样，但是超级简单，自行百度即可！

3）使用默认用户密码登陆
//输入用户名密码
Centos7安装Docker镜像仓库Harbor1.5.3
注：默认的用户名admin，密码Harbor12345。

//点击登陆
Centos7安装Docker镜像仓库Harbor1.5.3

Harbor服务端上传下载镜像
1、创建普通上传镜像用户
注：创建用户时按照密码复杂要求设置密码！

2、harbor服务器本地登陆
docker login harbor.123.com

报错：Error response from daemon: Get https://harbor.123.com/v1/users/: x509: certificate signed by unknown authority

解决方式

1、centos7系统以上报错的原因是因为自签的证书没有加入到系统级别信任，只需要将harbor.123.com.crt拷贝到/etc/pki/ca-trust/source/anchors/reg.你的域名.crt，然后需要执行命令update-ca-trust，最后重启harbor和docker即可！

2、ubunt16.04系统以上报错的原因是因为自签的证书没有加入到系统级别信任，只需要将harbor.123.com.crt拷贝到/usr/local/share/ca-certificates/reg.你的域名.crt，然后执行命令update-ca-certificates，最后重启harbor和docker即可！
Centos7安装Docker镜像仓库Harbor1.5.3
Centos7安装Docker镜像仓库Harbor1.5.3
Centos7安装Docker镜像仓库Harbor1.5.3

3、为镜像打标记
docker tag 原镜像名 harbor.123.com /项目名/打标记的镜像名
Centos7安装Docker镜像仓库Harbor1.5.3 
注：如果是普通用户推送镜像，切记需要创建项目，不然上传给默认的library项目没有权限，只有admin用户有推送library项目的权利。

4、推送镜像到harbor仓库
//先登录镜像库

docker login harbor.123.com
Username: admin
Password:

//推送镜像到仓库

docker push harbor.123.com/library/tomcat:v1
Centos7安装Docker镜像仓库Harbor1.5.3 
注：如果是普通用户推送镜像，那么以上的library项目名换成自己的项目名即可！

5、拉取镜像
//删除打标记的镜像

docker rmi -f harbor.123.com/library/tomcat:v1
Centos7安装Docker镜像仓库Harbor1.5.3

//拉取仓库的tomcat镜像

docker pull 镜像的完整路径
Centos7安装Docker镜像仓库Harbor1.5.3
注：可能有童鞋会说，如果不知道怎么填写完整路径怎么办，也不知道怎么下载镜像的，那么就登录上网页harbor，然后点击你要下载的那个镜像后边pull命令提醒，例如：

6、docker退出harbor登陆
docker logout harbor的域名
Centos7安装Docker镜像仓库Harbor1.5.3

Harbor客户端上传下载镜像
由于通过openssl创建的是不可信的，直接拉取或登录时会报“x509: certificate signed by unknown authority”，故需要让客户机信任该证书。

1、从CA服务器将证书拷贝到客户端/root/目录下
scp /data/cert/harbor.123.com.crt root@192.168.152.91:/root/
Centos7安装Docker镜像仓库Harbor1.5.3

2、客户端将证书追加到自己的ca-bundle.crt认证文件中
cat harbor.123.com.crt >> /etc/pki/tls/certs/ca-bundle.crt

3、客户端/etc/hosts文件里追加服务端的IP和域名
echo "192.168.152.170 harbor.123.com" >>/etc/hosts

4、关闭harbor服务
//进入harbor目录

cd /data/harbor/

//关闭harbor服务

docker-compose stop

5、重启docker
systemctl restart docker

6、启动harbor服务
//进入harbor目录

cd /data/harbor/

//启动harbor服务

docker-compose up –d

7、docker登陆harbor
docker login harbor.123.com
Centos7安装Docker镜像仓库Harbor1.5.3 
注：废话就不多说了，其他的打标记、上传、下载，方式都一样！

原因：docker镜像仓库暂不支持https


解决方案：

在”/etc/docker/“目录下，创建”daemon.json“文件(如果有的话直接覆盖)。在文件中写入


{ "insecure-registries":["172.17.8.201:8003"] }

然后重启docker服务

就OK啦