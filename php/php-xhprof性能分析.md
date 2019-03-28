 xhprof 版本是从 https://github.com/longxinH/xhprof 获取
cd /usr/local/src
git clone https://github.com/longxinH/xhprof
安装 xhprof
cd xhprof/extension/
/usr/local/php/bin/phpize
/configure --with-php-config=/usr/local/php/bin/php-config
make
make install

cd /tmp/
mkdir xhprof
chown www.www xhprof/

然后在/usr/local/php/etc/php.ini中根据情况加入

```
[xhprof]
extension = xhprof.so
xhprof.output_dir = /tmp/xhprof
```

报错
failed to execute cmd：" dot -Tpng". stderr：sh： dot：command not found。
//解决方案
yum install graphviz

php.ini设置了禁用proc_open方法
如果安装好了graphviz，仍然出现”failed to execute cmd”,检查下服务器上的php.ini中disable_functions这项是不是限制了proc_open，因为在xhprof_lib/utils/callgraph_utils.php的xhprof_generate_image_by_dot中使用了proc_open函数， 

重启php-fpm nginx
```
/etc/init.d/php-fpm reload
/etc/init.d/nginx reload
```


切换到下载的 xhprof 目录 拷贝到网站根目录

cd /usr/local/src/
cp -r xhprof/xhprof_html  ROOT_PATH/
cp -r xhprof/xhprof_lib ROOT_PATH/


- 函数的前后包裹 

``` php
[root@lnmp1 phpmyadmin]# cat sample.php 
<?php


// start profiling 加到文件头部
xhprof_enable();

// run program 文件代码
phpinfo();
// stop profiler 加到文件尾部
$xhprof_data = xhprof_disable();

// display raw xhprof data for the profiler run
print_r($xhprof_data);

include_once "/data/wwwroot/ip/sale/xhprof_lib/utils/xhprof_lib.php";
include_once "/data/wwwroot/ip/sale/xhprof_lib/utils/xhprof_runs.php";

// save raw data for this profiler run using default
// implementation of iXHProfRuns.
$xhprof_runs = new XHProfRuns_Default();

// save the run under a namespace "xhprof_foo"
$run_id = $xhprof_runs->save_run($xhprof_data, "xhprof_foo");

echo "---------------\n".
     "Assuming you have set up the http based UI for \n".
     "XHProf at some address, you can view run at \n".
     "http://<xhprof-ui-address>/index.php?run=$run_id&source=xhprof_foo\n".
     "---------------\n";
```

- 框架的注入
- 入口文件/data/wwwroot/ip/sale/index.php加入

```php
xhprof_enable(XHPROF_FLAGS_MEMORY | XHPROF_FLAGS_CPU);
register_shutdown_function(function() {
    $xhprof_data = xhprof_disable();
    if (function_exists('fastcgi_finish_request')){
        fastcgi_finish_request();
    }
    include_once "/data/wwwroot/ip/sale/xhprof_lib/utils/xhprof_lib.php";
    include_once "/data/wwwroot/ip/sale/xhprof_lib/utils/xhprof_runs.php";
    $xhprof_runs = new XHProfRuns_Default();
    $run_id = $xhprof_runs->save_run($xhprof_data, 'xhprof');
});
```
- 查看/tmp/xhprof的最新id
- 访问http://<host>/xhprof_html/index.php?run=5c99d50b0539a&source=xhprof