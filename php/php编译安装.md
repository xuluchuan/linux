./configure  '--prefix=/usr/local/php' '--with-config-file-path=/usr/local/php/etc' '--with-config-file-scan-dir=/usr/local/php/conf.d' '--enable-fpm' '--with-fpm-user=www' '--with-fpm-group=www' '--enable-mysqlnd' '--with-mysqli=mysqlnd' '--with-pdo-mysql=mysqlnd' '--with-iconv-dir' '--with-freetype-dir=/usr/local/freetype' '--with-jpeg-dir' '--with-png-dir' '--with-zlib' '--with-libxml-dir=/usr' '--enable-xml' '--disable-rpath' '--enable-bcmath' '--enable-shmop' '--enable-sysvsem' '--enable-inline-optimization' '--with-curl' '--enable-mbregex' '--enable-mbstring' '--enable-intl' '--enable-ftp' '--with-gd' '--with-openssl' '--with-mhash' '--enable-pcntl' '--enable-sockets' '--with-xmlrpc' '--enable-zip' '--enable-soap' '--with-gettext' '--disable-fileinfo' '--enable-opcache' '--with-xsl'

make ZEND_EXTRA_LIBS='-liconv'

make install


安装PHP出现make: *** [sapi/cli/php] Error 1 解决办法
2018年10月23日 10:32:02 zhou75771217 阅读数：916
 版权声明：请注明出处 https://blog.csdn.net/zhou75771217/article/details/83303199
ext/iconv/.libs/iconv.o: In function `php_iconv_stream_filter_ctor':
/home/king/php-5.2.13/ext/iconv/iconv.c:2491: undefined reference to `libiconv_open'
collect2: ld returned 1 exit status
make: *** [sapi/cli/php] Error 1
[root@test php-5.2.13]# vi Makefile

在安裝 PHP 到系统中时要是发生「undefined reference to libiconv_open'」之类的错误信息，那表示在「./configure 」沒抓好一些环境变数值。错误发生点在建立「-o sapi/cli/php」是出错，没給到要 link 的 iconv 函式库参数。 解决方法：编辑Makefile 大约77 行左右的地方: EXTRA_LIBS = ..... -lcrypt 在最后加上 -liconv，例如: EXTRA_LIBS = ..... -lcrypt -liconv 然后重新再次 make 即可。

或者用另一种办法

make ZEND_EXTRA_LIBS='-liconv'

ln -s /usr/local/lib/libiconv.so.2 /usr/lib64/

作者用的第一种办法解决的,编译好Makefile后，记得先make clean一下，再make，不然会报错