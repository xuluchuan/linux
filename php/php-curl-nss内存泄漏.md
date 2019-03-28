strace -o output.txt -T -tt -e trace=all -p 9168

centos系统中php Curl 无法访问https ，更换ssl_version NSS为openssl
2017年12月07日 16:38:51 MAX3214 阅读数：2960
在centos 6上面,curl模块的ssl 支持默认为NSS，涉及到的程序里有https，是需要双向认证的，这时使用NSS会报错,所以需要更换为openssl.

一、查看系统自带的curl的版本

[root@localhost local]# curl -V
curl 7.19.7
二、得到curl当前版本是7.19.7，我们去官方下载http://curl.haxx.se/download/archeology/ 同样版本,然后解压、编译。

wget http://curl.haxx.se/download/archeology/curl-7.19.7.tar.gz
tar -zxf curl-7.19.7.tar.gz
cd curl-7.19.7
./configure --without-nss --with-ssl
make && make install
#–without-nss 禁用nss, –with-ssl启用openssl的支持.

三、将curl的库载入动态共享文件,并重新加载

echo "/usr/local/lib" >> /etc/ld.so.conf
ldconfig
四、查看新安装后curl的版本

[root@localhost local]# curl -V
curl 7.19.7 (x86_64-unknown-linux-gnu) libcurl/7.19.7 OpenSSL/1.0.1e zlib/1.2.3 libidn/1.18
Protocols: tftp ftp telnet dict http file https ftps
Features: IDN IPv6 Largefile NTLM SSL libz
五、重启你的httpd/nginx服务和php服务器

service nginx restart #或service httpd restart
service php-fpm restart