cd /usr/local/src
git clone https://github.com/swoole/swoole-src.git  
cd swoole-src
/usr/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make clean;make;make install
编辑php.ini

vi /usr/local/php/etc/php.ini

添加一行

extension=swoole.so


重启服务

service php-fpm restart



查看swoole模块是否已加载

php -m