#!/bin/bash
startTime=`date +%Y%m%d-%H:%M:%S`
startTime_s=`date +%s`
/usr/bin/php /data/wwwroot/manage_second/manage/Redstar/tools/Task/analysis.php --dodel 1 &
wait
for i in `seq 1 6`
do
{
    /usr/bin/php /data/wwwroot/manage_second/manage/Redstar/tools/Task/analysis.php --start_time 2018-09-01 --end_time 2019-03-27 --branch $i
} &
done
wait  ##等待所有子后台进程结束
/usr/bin/php /data/wwwroot/manage_second/manage/Redstar/tools/Task/analysis.php --start_time 2018-09-01 --end_time 2019-03-27 --branch 7 &
wait
endTime=`date +%Y%m%d-%H:%M:%S`
endTime_s=`date +%s`
sumTime=$[ $endTime_s - $startTime_s ]
echo "$startTime ---> $endTime" "Totl:$sumTime seconds"