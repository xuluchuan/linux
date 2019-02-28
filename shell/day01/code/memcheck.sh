#!/usr/bin/env bash
freeMem=`free -m|awk 'NR==2{print $NF}'`
if [[ ${freeMem} -le 200 ]]; then
    echo "内存不足200M"|mail -s "内存不足报警" xxx@qq.com
fi