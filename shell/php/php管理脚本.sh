#!/bin/bash
function start() {
    sed -i '1a\xhprof_enable(XHPROF_FLAGS_MEMORY | XHPROF_FLAGS_CPU);\nregister_shutdown_function(function() {\n    $xhprof_data = xhprof_disable();\n    if (function_exists('fastcgi_finish_request')){\n        fastcgi_finish_request();\n    }\n    include_once "/data/wwwroot/ip/sale/xhprof_lib/utils/xhprof_lib.php";\n    include_once "/data/wwwroot/ip/sale/xhprof_lib/utils/xhprof_runs.php";\n    $xhprof_runs = new XHProfRuns_Default();\n    $run_id = $xhprof_runs->save_run($xhprof_data, 'xhprof');\n});' /data/wwwroot/ip/sale/index.php
    echo "debug start ok!"
}

function stop() {
    sed -i '2,12d' /data/wwwroot/ip/sale/index.php
    echo "debug stop ok!"
}

function status() {
    sed -n 2p /data/wwwroot/ip/sale/index.php|grep "xhprof_enable" > /dev/null 2>&1
    if [[ $? != 0 ]];then
        echo "debug now status stop"
        return 1 
    else
        echo "debug now status start"
        return 2
    fi
}

case $1 in
start)
    status >/dev/null 2>&1
    retval=$?
    if [ $retval -eq 1 ];then
        start
    else
        echo "debug already start"
    fi
    ;;
stop)
    status >/dev/null 2>&1
    retval=$?
    if [ $retval -eq 2 ];then
        stop
    else
        echo "debug already stop"
    fi
    ;;
status)
    status
    ;;
*)
    echo "usage:start | stop | status"
    ;;
esac
