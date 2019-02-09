#!/usr/bin/env bash
read -p "请输入第一个整数：" a
read -p "请输入第二个整数：" b
sum1=$[${a}+${b}]
echo "两数字和是${sum1}"
if [[ ${a} -gt ${b} ]];then
    echo "最大值是${a}"
else
    echo "最大值是${b}"
fi
